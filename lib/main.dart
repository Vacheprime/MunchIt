import 'package:flutter/material.dart';
import 'package:munchit/view/splashscreen.dart';
import 'package:munchit/services/firebase/firebasemanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseManager.initFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
