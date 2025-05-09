import 'dart:async';
import 'package:flutter/material.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/repositories/user_repository.dart';
import '../services/firebase/firebasemanager.dart';
import 'Login/homepage.dart';

class Splash extends StatefulWidget {
  final Function(User) onUserLoaded;

  const Splash({Key? key, required this.onUserLoaded}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(const Duration(seconds: 4), () async {
      UserRepository userRepository = new UserRepository();
      User? user = await userRepository.getLoggedInUser();

      widget.onUserLoaded(user!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Homepage(),
      ));
    }); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
