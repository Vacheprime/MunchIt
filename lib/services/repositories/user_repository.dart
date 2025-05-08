import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/exceptions/FirestoreInsertException.dart';
import 'package:munchit/services/repositories/base_repository.dart';
import 'package:munchit/services/repositories/food_repository.dart';
import 'package:munchit/services/repositories/restaurant_repository.dart';
import 'package:munchit/services/repositories/review_repository.dart';

final class UserRepository extends BaseRepository<UserRepository> {
  static const String collectionName = "users";

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
    if (user.comparePassword(password)) return user;
    return null;
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
