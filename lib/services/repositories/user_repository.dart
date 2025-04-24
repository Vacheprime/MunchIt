import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/exceptions/FirestoreInsertException.dart';
import 'package:munchit/services/firebase/firebasemanager.dart';
import 'package:munchit/services/repositories/base_repository.dart';

final class UserRepository extends BaseRepository<UserRepository> {
  static const String collectionName = "users";

  UserRepository(): super(collectionName);

  UserRepository._fromFilter(Query<Map<String, dynamic>> query): super.fromFilter(collectionName, query);

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

  UserRepository withUserName(String userName) {
    return applyTransform((Query<Map<String, dynamic>> query) {
      return query.where("username", isEqualTo: userName);
    });
  }


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

  @override
  UserRepository clone(RepositoryQuery newQuery) {
    return UserRepository._fromFilter(newQuery);
  }
}