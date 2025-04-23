import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/repositories/base_repository.dart';

class UserRepository extends BaseRepository<UserRepository> {
  static const String collectionName = "users";

  UserRepository(): super(collectionName);

  UserRepository._fromFilter(Query<Map<String, dynamic>> query): super.fromFilter(collectionName, query);

  Future<User?> attemptLogin(String userName, String password) async {
    if (await withUserName(userName).count() != 1) {
      return null;
    }

  }

  UserRepository withUserName(String userName) {
    return applyTransform((Query<Map<String, dynamic>> query) {
      return query.where("username", isEqualTo: userName);
    });
  }

  @override
  UserRepository clone(Query<Map<String, dynamic>> newQuery) {
    return UserRepository._fromFilter(newQuery);
  }

}