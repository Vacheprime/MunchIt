import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/exceptions/FirestoreInsertException.dart';
import 'package:munchit/services/repositories/base_repository.dart';
import 'package:munchit/services/repositories/food_repository.dart';
import 'package:munchit/services/repositories/restaurant_repository.dart';
import 'package:munchit/services/repositories/review_repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

final class UserRepository extends BaseRepository<UserRepository> {
  static const String collectionName = "users";
  static const String credentialsFileName = "user_credentials.json";

  /// Default constructor.
  UserRepository(): super(collectionName);

  /// Constructor used to create a clone from a filter.
  UserRepository._fromFilter(RepositoryQuery query, List<Transformation> transformations): super.fromFilter(collectionName, query, transformations);

  /// Attempt to login a user using a [userName] and a [password].
  Future<User?> attemptLogin(String userName, String password) async {
    if (await this.withUserName(userName).count() != 1) {
      return null;
    }
    // Fetch the user
    List<User> result = await this.withUserName(userName).retrieve();
    // Check if user exists
    if (result.length != 1) return null;
    // Check if passwords match
    User user = result[0];
    if (user.comparePassword(password)) {
      // Save credentials
      _saveLoginCredentials(userName, password);
      return user;
    }
    return null;
  }

  Future<User?> getLoggedInUser() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    File credentialsFile = File(join(docsDir.path, credentialsFileName));
    print(credentialsFile.path);
    // Check if file exists
    if (!(await credentialsFile.exists())) {
      // Copy asset to writeable store
      await _copyAssetToWritableStorage("lib/config/$credentialsFileName", credentialsFileName);
    }
    // Read credentials
    String data = await credentialsFile.readAsString();
    // Attempt to parse
    Map<String, dynamic> credentials = {};
    try {
      credentials = jsonDecode(data);
    } catch (e) {
      print("Error reading credentials file: $e");
      return null;
    }
    // Attempt to login
    return (await attemptLogin(credentials["username"], credentials["password"]));
  }

  Future<void> _copyAssetToWritableStorage(String asset, String fileName) async {
    // Get documents directory
    Directory dir = await getApplicationDocumentsDirectory();
    // Get asset data
    String data = await rootBundle.loadString(asset);
    // Copy to writeable file
    File writeableFile = File(join(dir.path, fileName));
    await writeableFile.writeAsString(data, flush: true);
  }

  Future<void> _saveLoginCredentials(String username, String password) async {
    // Get documents directory
    Directory dir = await getApplicationDocumentsDirectory();
    // Get file
    File credentialsFile = File(join(dir.path, credentialsFileName));
    // Get credentials as json string
    Map<String, String> credentialsMap = {"username": username, "password": password};
    await credentialsFile.writeAsString(jsonEncode(credentialsMap));
  }

  Future<void> eraseCredentials() async {
    // Get documents directory
    Directory dir = await getApplicationDocumentsDirectory();
    // Get file
    File credentialsFile = File(join(dir.path, credentialsFileName));
    // Delete the credentials
    await credentialsFile.delete();
  }

  /// Filter users that have the given [userName].
  UserRepository withUserName(String userName) {
    return applyTransform((RepositoryQuery query) {
      return query.where("username", isEqualTo: userName);
    });
  }

  /// Check if the username is already taken
  Future<bool> isUserNameTaken(String userName) async {
    // Get a new query
    CollectionReference reference = firestore.collection(collectionName);
    // Count query
    AggregateQuerySnapshot snapshot = await reference.where("username", isEqualTo: userName).count().get();
    // Return if exists
    return snapshot.count! == 1;
  }

  /// Add the specified [user] into the database.
  Future<void> add(User user) async {
    // Get the collection reference
    CollectionReference reference = firestore.collection(collectionName);
    try {
      // Insert the user and set its document ID
      DocumentReference ref = await reference.add(user.toMap());
      user.setDocId(ref.id);
    } catch (e) {
      throw FirestoreInsertException("An error occurred during the insertion"
          "of the user.", e);
    }
  }

  Future<void> update(User user) async {
    // Get colelction ref
    CollectionReference collection = getCollectionReference();
    try {
      // Update the user
      await collection.doc(user.getDocId()).update(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> _mapFromSnapshots(List<DocumentSnapshot> docs) async {
    List<User> users = [];
    for (DocumentSnapshot doc in docs) {
      // Get the data
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

      // Instantiate the repositories
      RestaurantRepository restaurantRepository = RestaurantRepository();
      FoodRepository foodRepository = FoodRepository();
      ReviewRepository reviewRepository = ReviewRepository();

      // Get the liked restaurants
      List<String> likedRestaurantIds = List<String>.from(data["likedRestaurants"]);
      data["likedRestaurants"] = await restaurantRepository.getFromIds(likedRestaurantIds);

      // Get the saved restaurants
      List<String> savedRestaurantIds = List<String>.from(data["savedRestaurants"]);
      data["savedRestaurants"] = await restaurantRepository.getFromIds(savedRestaurantIds);

      // Get the created restaurants
      List<String> createdRestaurantIds = List<String>.from(data["createdRestaurants"]);
      data["createdRestaurants"] = await restaurantRepository.getFromIds(createdRestaurantIds);

      // Get the created foods
      List<String> createdFoodIds = List<String>.from(data["createdFoods"]);
      data["createdFoods"] = await foodRepository.getFromIds(createdFoodIds);

      // Get the created reviews
      List<String> createdReviews = List<String>.from(data["createdReviews"]);
      data["createdReviews"] = await reviewRepository.getFromIds(createdReviews);

      // Add the user to the users list
      users.add(User.fromFirebase(doc.id, data));
    }
    return users;
  }

  /// Retrieve the results of the current query of the
  /// UserRepository.
  @override
  Future<List<User>> retrieve() async {
    // Get the query
    RepositoryQuery query = getQueryClone();
    // Fetch the data
    QuerySnapshot snapshot = await query.get();
    // Get the documents
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    return await _mapFromSnapshots(docs);
  }

  /// Clone the UserRepository.
  @override
  UserRepository clone(RepositoryQuery newQuery, List<Transformation> transformations) {
    return UserRepository._fromFilter(newQuery, transformations);
  }
}
