import 'package:cloud_firestore/cloud_firestore.dart';

typedef MappingFunction<E> = List<E> Function(List<QueryDocumentSnapshot<Map<String, dynamic>>>);
typedef Transformation = Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>);
typedef RepositoryQuery = Query<Map<String, dynamic>>;

abstract class BaseRepository<T extends BaseRepository<T>> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String _collectionName;
  List<Transformation> _queryTransformations = [];
  late Query<Map<String, dynamic>> _query;

  BaseRepository(this._collectionName) {
    _query = firestore.collection(_collectionName);
  }

  BaseRepository.fromFilter(this._collectionName, RepositoryQuery query, List<Transformation> transformations) {
    _query = query;
    _queryTransformations = transformations;
  }

  Future<int> count() async {
    AggregateQuerySnapshot querySnapshot = await _query.count().get();
    return querySnapshot.count!;
  }

  /// Get a clone of the current query
  RepositoryQuery getQueryClone() {
    // Create a new query
    RepositoryQuery clonedQuery = firestore.collection(_collectionName);
    // Apply all query transformations
    for (int i = 0; i < _queryTransformations.length; i++) {
      clonedQuery = _queryTransformations[i](clonedQuery);
    }
    // Return the cloned query
    return clonedQuery;
  }

  CollectionReference getCollectionReference() {
    return firestore.collection(_collectionName);
  }

  T applyTransform(Transformation transform) {
    RepositoryQuery newQuery = transform(_query);
    // Clone
    BaseRepository<T> cloned = clone(newQuery, [..._queryTransformations]);
    // Add to transformations
    cloned._queryTransformations.add(transform);
    // Return the new query
    return cloned as T;
  }

  /// Retrieves the result of the query.
  Future<List<Object>> retrieve();

  /// Abstract clone method.
  /// Defines how subclasses are to be cloned.
  T clone(RepositoryQuery newQuery, List<Transformation> transformations);
}