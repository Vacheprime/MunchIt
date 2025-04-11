import 'package:firebase_core/firebase_core.dart';

/// FirebaseManager class is used to define Firebase/Firestore specific operations.
class FirebaseManager {

  /// Initialize the Firebase application with the appropriate arguments.
  static Future<void> initFirebase() async {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC_KGMbKS-_yfVyOBhFScUXle9LAWdzDds",
            appId: "461033269569",
            messagingSenderId: "461033269569",
            projectId: "munchit-967bf"));
  }
}