import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munchit/model/review.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/exceptions/FirestoreInsertException.dart';
import 'package:munchit/services/repositories/base_repository.dart';


final class ReviewRepository extends BaseRepository<ReviewRepository> {
  static const String collectionName = "reviews";

  ReviewRepository(): super(collectionName);

  ReviewRepository._fromFilter(RepositoryQuery query, List<Transformation> transformations): super.fromFilter(collectionName, query, transformations);

  Future<List<Review>> getFromIds(int docId) async {


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