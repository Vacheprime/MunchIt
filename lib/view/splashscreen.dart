import 'dart:async';
import 'package:flutter/material.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/repositories/user_repository.dart';
import 'Login/homepage.dart';
import 'mainpage.dart';

class Splash extends StatefulWidget {
  // This function is passed from MyApp() and is used to set the MaterialApp
  // theme.
  final void Function(ThemeMode) setThemeCallback;
  const Splash({Key? key, required this.setThemeCallback}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserWithDelay(2);
  }

  /// Attempt to login the user based on the cached credentials
  ///
  /// Wait [seconds] amount of seconds to display the Splash screen.
  Future<void> _loadUserWithDelay(int seconds) async {
    // Delay
    await Future.delayed(Duration(seconds: seconds));
    // Attempt to login
    UserRepository userRepository = UserRepository();
    User? user = await userRepository.getLoggedInUser();
    // Check whether cached login worked or not
    if (user == null) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      // Set the dark/light mode
      widget.setThemeCallback(user.settings.isDarkModeEnabled() ? ThemeMode.dark : ThemeMode.light);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage(user)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Munch't",
              style: TextStyle(fontSize: 36),
            ),
            SizedBox(
              height: 20,
            ),
            Icon(
              Icons.local_restaurant,
              size: 200,
            )
          ],
        ),
      ),
    );
  }
}
