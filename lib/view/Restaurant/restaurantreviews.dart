import 'package:flutter/material.dart';
import '../../model/restaurant.dart';
import '../../model/user.dart';

class RestaurantReviews extends StatefulWidget {
  final User user;
  final Restaurant restaurant;

  const RestaurantReviews({super.key, required this.user, required this.restaurant});

  @override
  State<RestaurantReviews> createState() => _RestaurantReviewsState();
}

class _RestaurantReviewsState extends State<RestaurantReviews> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(

      ),
    );
  }
}
