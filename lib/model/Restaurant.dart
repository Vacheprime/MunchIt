import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'Review.dart';

class Restaurant {
  // Information
  int id;
  String name;
  double price;
  String location;
  Map<String, String> allergies;
  ImageProvider image;
  // Statistics
  int likes;
  int saves;
  List<Review> reviews;


  Restaurant ({
    required this.id,
    required this.name,
    required this.price,
    required this.location,
    required this.allergies,
    required this.image,
    required this.likes,
    required this.saves,
    required this.reviews,
  });
}