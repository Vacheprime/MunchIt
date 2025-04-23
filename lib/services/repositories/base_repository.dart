import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseRepository<T extends BaseRepository<T>> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _collectionName;
  late Query<Map<String, dynamic>> _query;

  BaseRepository(this._collectionName) {
    _query = firestore.collection(_collectionName);
  }

  BaseRepository.fromFilter(this._collectionName, Query<Map<String, dynamic>> query) {
    _query = query;
  }

  Future<int> count() async {
    AggregateQuerySnapshot querySnapshot = await _query.count().get();
    return querySnapshot.count!;
  }

  /// Retrieves the result of the query.
  Future<List<E>> retrieve<E>(List<E> Function(List<QueryDocumentSnapshot<Map<String, dynamic>>>) mappingFunction) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _query.get();
    List<E> results = mappingFunction(snapshot.docs);
    return results;
  }

  T applyTransform(Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>) transform) {
    Query<Map<String, dynamic>> newQuery = transform(_query);
    // Clone
    BaseRepository<T> cloned = clone(newQuery);
    // Return the new query
    return cloned as T;
  }

  /// Abstract clone method.
  /// Defines how subclasses are to be cloned.
  T clone(Query<Map<String, dynamic>> newQuery);
}