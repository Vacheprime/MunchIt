import 'package:flutter/material.dart';
import '../../model/user.dart';
import '../../model/food.dart';

class FoodInfo extends StatefulWidget {
  final User user;
  final Food food;

  const FoodInfo({super.key, required this.user, required this.food});

  @override
  State<FoodInfo> createState() => _FoodInfoState();
}

class _FoodInfoState extends State<FoodInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
