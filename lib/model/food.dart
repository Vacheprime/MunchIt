import 'package:flutter/material.dart';
import 'package:munchit/services/utils/utils.dart';
import 'review.dart';

/// Food class is used to represent a menu item of a restaurant.
class Food {
  String? _docId;
  late String _name;
  late double _price;
  late ImageProvider _image;
  late String _allergies;
  bool _hasNuts = false;
  bool _hasPeanuts = false;
  int _likes = 0;
  int _saves = 0;
  final List<Review> _reviews = [];

  Food(String name, double price, ImageProvider image, {bool hasNuts = false, bool hasPeanuts = false, String allergies = ""}) {
    setName(name);
    setPrice(price);
    setImage(image);
    setAllergies(allergies);
    _hasNuts = hasNuts;
    _hasPeanuts = hasPeanuts;
  }

  String? getDocId() {
    return _docId;
  }

  void setDocId(String docId) {
    _docId = docId;
  }

  String getName() {
    return _name;
  }

  void setName(String name) {
    if (!validateName(name)) throw ArgumentError("The name is invalid!");
    _name = name;
  }

  double getPrice() {
    return _price;
  }

  void setPrice(double price) {
    if (!validatePrice(price)) throw ArgumentError("The price is invalid!");
    _price = price;
  }

  ImageProvider getImage() {
    return _image;
  }

  void setImage(ImageProvider image) {
    _image = image;
  }

  String getAllergies() {
    return _allergies;
  }

  void setAllergies(String allergies) {
    if (!validateAllergies(allergies)) throw ArgumentError("The allergies are invalid!");
    _allergies = allergies;
  }

  bool hasNuts() {
    return _hasNuts;
  }

  void setHasNuts(bool hasNuts) {
    _hasNuts = hasNuts;
  }

  bool hasPeanuts() {
    return _hasPeanuts;
  }

  void setHasPeanuts(bool hasPeanuts) {
    _hasPeanuts = hasPeanuts;
  }

  int getLikes() {
    return _likes;
  }

  void addLike() {
    _likes++;
  }

  void removeLike() {
    _likes--;
  }

  int getSaves() {
    return _saves;
  }

  void addSave() {
    _saves++;
  }

  void removeSave() {
    _saves--;
  }

  List<Review> getReviews() {
    return _reviews;
  }

  void addReview(Review review) {
    _reviews.add(review);
  }

  void removeReview(Review review) {
    _reviews.remove(review);
  }

  double getRating() {
    return _reviews.map((review) => review.getRating()).reduce((r1, r2) => r1 + r2) / _reviews.length;
  }

  static bool validateName(String name) {
    if (Utils.hasInvalidSpaces(name)) return false;
    RegExp validNameRegex = RegExp(r"^[\p{L} ]+$", unicode: true);
    return validNameRegex.hasMatch(name);
  }

  static bool validatePrice(double price) {
    return price > 0;
  }

  static bool validateAllergies(String allergies) {
    if (allergies.isEmpty) return true;
    if (Utils.hasInvalidSpaces(allergies)) return false;
    RegExp validAllergiesRegex = RegExp(r"^[\p{L},; ]$", unicode: true);
    return validAllergiesRegex.hasMatch(allergies);
  }
}