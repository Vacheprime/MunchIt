import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munchit/model/food.dart';
import 'package:munchit/model/review.dart';
import 'package:munchit/services/exceptions/FirestoreInsertException.dart';
import 'package:munchit/services/repositories/base_repository.dart';


final class FoodRepository extends BaseRepository<FoodRepository> {
  static const String collectionName = "foods";

  FoodRepository(): super(collectionName);

  FoodRepository._fromFilter(RepositoryQuery query, List<Transformation> transformations): super.fromFilter(collectionName, query, transformations);

  Future<void> add(Food food) async {
    // Get the collection reference
    CollectionReference collection = getCollectionReference();
    try {
      // Insert the review and set its document ID
      DocumentReference ref = await collection.add(food.toMap());
      food.setDocId(ref.id);
    } catch (e) {
      throw FirestoreInsertException("An error occurred during the insertion"
          "of the food.", e);
    }
  }

  Future<List<Food>> getFromIds(List<String> docIds) async {
    CollectionReference collection = getCollectionReference();
    List<Food> foodItems = [];
    for (int i = 0; i < docIds.length; i++) {
      // Fetch review document
      DocumentSnapshot document = await collection.doc(docIds[i]).get();
      // Create review object
      Food food = Food.fromFirebase(document.id, document.data()! as Map<String, dynamic>);
      // Add to reviews list
      foodItems.add(food);
    }
    return foodItems;
  }

  @override
  FoodRepository clone(RepositoryQuery newQuery, List<Transformation> transformations) {
    return FoodRepository._fromFilter(newQuery, transformations);
  }

  @override
  Future<List<Object>> retrieve() {
    // TODO: implement retrieve
    throw UnimplementedError();
  }
}