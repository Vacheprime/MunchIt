import 'package:flutter/material.dart';

import '../../model/User.dart';

class StatDetails extends StatefulWidget {
  final User user;

  const StatDetails({super.key, required this.user});

  @override
  State<StatDetails> createState() => _StatDetailsState();
}

class _StatDetailsState extends State<StatDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        //generate list based off the user's stats such as likes, saved, reviews, created restaurants and foods
      ),
    );
  }
}
