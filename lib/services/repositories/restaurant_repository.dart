import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munchit/model/food.dart';
import 'package:munchit/model/restaurant.dart';
import 'package:munchit/model/review.dart';
import 'package:munchit/services/exceptions/FirestoreInsertException.dart';
import 'package:munchit/services/repositories/base_repository.dart';
import 'package:munchit/services/repositories/food_repository.dart';
import 'package:munchit/services/repositories/review_repository.dart';

final class RestaurantRepository extends BaseRepository<RestaurantRepository> {
  static const String collectionName = "restaurants";

  RestaurantRepository(): super(collectionName);

  RestaurantRepository._fromFilter(RepositoryQuery query, List<Transformation> transformations): super.fromFilter(collectionName, query, transformations);

  Future<void> add(Restaurant restaurant) async {
    // Get the collection reference
    CollectionReference collection = getCollectionReference();
    try {
      // Insert the restaurant and set its document ID
      DocumentReference ref = await collection.add(restaurant.toMap());
      restaurant.setDocId(ref.id);
    } catch (e) {
      throw FirestoreInsertException("An error occurred during the insertion"
          "of the restaurant.", e);
    }
  }

  Future<List<Restaurant>> getFromIds(List<String> docIds) async {
    CollectionReference collection = getCollectionReference();
    List<DocumentSnapshot> docs = [];
    for (String id in docIds) {
      docs.add(await collection.doc(id).get());
    }
    return _mapFromSnapshots(docs);
  }

  Future<List<Restaurant>> _mapFromSnapshots(List<DocumentSnapshot> docs) async {
    // Define the list of restaurants
    List<Restaurant> restaurants = [];
    for (DocumentSnapshot doc in docs) {
      // Get the data
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

      // Get all restaurant food items
      FoodRepository foodRepository = FoodRepository();
      List<String> foodItemIds = List<String>.from(data["foodItems"]);
      List<Food> foodItems = await foodRepository.getFromIds(foodItemIds);

      // Alter the data
      data["foodItems"] = foodItems;

      // Get all restaurant reviews
      ReviewRepository reviewRepository = ReviewRepository();
      List<String> reviewIds = List<String>.from(data["reviews"]);
      List<Review> reviews = await reviewRepository.getFromIds(reviewIds);
      // Alter the data
      data["reviews"] = reviews;

      // Add the restaurant
      restaurants.add(Restaurant.fromFirebase(doc.id, data));
    }
    return restaurants;
  }

  @override
  RestaurantRepository clone(RepositoryQuery newQuery, List<Transformation> transformations) {
    return RestaurantRepository._fromFilter(newQuery, transformations);
  }

  @override
  Future<List<Restaurant>> retrieve() async {
    // Get the query
    RepositoryQuery query = getQueryClone();
    // Fetch the data
    QuerySnapshot snapshot = await query.get();
    // Get the documents
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    return await _mapFromSnapshots(docs);
  }
}
