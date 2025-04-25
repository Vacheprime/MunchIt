import 'dart:io';
import 'package:flutter/material.dart';
import 'package:munchit/view/splashscreen.dart';
import 'package:munchit/services/firebase/firebasemanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseManager.initFirebase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
