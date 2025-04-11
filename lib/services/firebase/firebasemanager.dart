import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class FirebaseManager {
  static Future<void> initFirebase() async {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC_KGMbKS-_yfVyOBhFScUXle9LAWdzDds",
            appId: "461033269569",
            messagingSenderId: "461033269569",
            projectId: "munchit-967bf"));
  }
}