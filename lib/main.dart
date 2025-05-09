import 'package:flutter/material.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/firebase/firebasemanager.dart';
import 'package:munchit/view/mainpage.dart';
import 'package:munchit/view/splashscreen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseManager.initFirebase();

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      ),
    ],
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  User? _currentUser;

  /// Called by SplashScreen after loading the user from Firebase.
  void _onUserLoaded(User user) {
    setState(() {
      _currentUser = user;
      _themeMode =
      user.settings.isDarkModeEnabled() ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MunchIt',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: _currentUser == null
          ? Splash(onUserLoaded: _onUserLoaded)
          : MainPage(_currentUser!),
    );
  }
}