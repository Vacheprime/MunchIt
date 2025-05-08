import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munchit/model/review.dart';
import 'package:munchit/services/exceptions/FirestoreInsertException.dart';
import 'package:munchit/services/repositories/base_repository.dart';


final class ReviewRepository extends BaseRepository<ReviewRepository> {
  static const String collectionName = "reviews";

  ReviewRepository(): super(collectionName);

  ReviewRepository._fromFilter(RepositoryQuery query, List<Transformation> transformations): super.fromFilter(collectionName, query, transformations);

  Future<void> add(Review review) async {
    // Get the collection reference
    CollectionReference collection = getCollectionReference();
    try {
      // Insert the review and set its document ID
      DocumentReference ref = await collection.add(review.toMap());
      review.setDocId(ref.id);
    } catch (e) {
      throw FirestoreInsertException("An error occurred during the insertion"
          "of the review.", e);
    }
  }

  Future<List<Review>> getFromIds(List<String> docIds) async {
    CollectionReference collection = getCollectionReference();
    List<Review> reviews = [];
    for (int i = 0; i < docIds.length; i++) {
      // Fetch review document
      DocumentSnapshot document = await collection.doc(docIds[i]).get();
      // Create review object
      Review review = Review.fromFirebase(document.id, document.data()! as Map<String, dynamic>);
      // Add to reviews list
      reviews.add(review);
    }
    return reviews;
  }

  @override
  Future<List<Review>> retrieve() {
    // TODO: implement retrieve
    throw UnimplementedError();
  }

  @override
  clone(RepositoryQuery newQuery, List<Transformation> transformations) {
    return ReviewRepository._fromFilter(newQuery, transformations);
  }
}