import 'dart:async';
import 'package:flutter/material.dart';
import 'Login/homepage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(
        Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homepage())));
  }

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
