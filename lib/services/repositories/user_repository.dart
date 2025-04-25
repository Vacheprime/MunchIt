import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/exceptions/FirestoreInsertException.dart';
import 'package:munchit/services/repositories/base_repository.dart';

import '../firebase/firebasemanager.dart';

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
      throw FirestoreInsertException("An error occured during the insertion"
          "of the user.", e);
    }
  }

  /// Retrieve the results of the current query of the
  /// UserRepository.
  @override
  Future<List<User>> retrieve() async {
    // Get the query
    RepositoryQuery query = getQueryClone();
    // Fetch the data
    QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
    // Get the documents
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
    // Get all users
    List<User> results = [];
    for (int i = 0; i < docs.length; i++) {
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot = docs[i];
      results.add(User.fromFirebase(snapshot.id, snapshot.data()));
    }
    return results;
  }

  /// Clone the UserRepository.
  @override
  UserRepository clone(RepositoryQuery newQuery, List<Transformation> transformations) {
    return UserRepository._fromFilter(newQuery, transformations);
  }
}