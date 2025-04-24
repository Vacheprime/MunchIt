import 'package:flutter/material.dart';

import '../../model/Restaurant.dart';
import '../../model/User.dart';

class RestaurantInfo extends StatefulWidget {
  final User user;
  final Restaurant restaurant;

  const RestaurantInfo({super.key, required this.user, required this.restaurant});

  @override
  State<RestaurantInfo> createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(

      ),
    );
  }
}
