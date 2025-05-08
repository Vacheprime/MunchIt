import 'package:flutter/material.dart';
import 'package:munchit/services/utils/utils.dart';
import 'review.dart';

/// Food class is used to represent a menu item of a restaurant.
class Food {
  String? _docId;
  late String _name;
  late double _price;
  late String _imageUrl;
  late String _allergies;
  bool _hasNuts = false;
  bool _hasPeanuts = false;
  int _likes = 0;
  int _saves = 0;
  final List<Review> _reviews = [];

  Food(String name, double price, String imageUrl,
      {bool hasNuts = false, bool hasPeanuts = false, String allergies = ""}) {
    setName(name);
    setPrice(price);
    setImageUrl(imageUrl);
    setAllergies(allergies);
    _hasNuts = hasNuts;
    _hasPeanuts = hasPeanuts;
  }

  factory Food.fromFirebase(String docId, Map<String, dynamic> data) {
    Food food = new Food(data["name"], data["price"], data["imageUrl"],
        hasNuts: data["hasNuts"],
        hasPeanuts: data["hasPeanuts"],
        allergies: data["allergies"]);
    food.setDocId(docId);
    food._likes = data["likes"];
    food._saves = data["saves"];
    food._addAllReviews(data["reviews"]);
    return food;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": _name,
      "price": _price,
      "imageUrl": _imageUrl,
      "allergies": _allergies,
      "hasNuts": _hasNuts,
      "hasPeanuts": _hasPeanuts,
      "likes": _likes,
      "saves": _saves,
      "reviews": _reviews
          .where((Review review) => review.getDocId() != null)
          .map((Review review) => review.getDocId())
    };
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

  String getImageUrl() {
    return _imageUrl;
  }

  void setImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
  }

  String getAllergies() {
    return _allergies;
  }

  void setAllergies(String allergies) {
    if (!validateAllergies(allergies)) {
      throw ArgumentError("The allergies are invalid!");
    }
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

  void _addAllReviews(List<Review> reviews) {
    _reviews.addAll(reviews);
  }

  void addReview(Review review) {
    _reviews.add(review);
  }

  void removeReview(Review review) {
    _reviews.remove(review);
  }

  double getRating() {
    return _reviews
            .map((review) => review.getRating())
            .reduce((r1, r2) => r1 + r2) /
        _reviews.length;
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
