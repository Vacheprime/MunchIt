import 'food.dart';
import 'package:munchit/services/utils/utils.dart';
import 'package:munchit/model/review.dart';

/// Restaurant class is used to represent a restaurant in the application.
class Restaurant {
  String? _docId;
  late String _name;
  late String _location;
  late String _phone;
  late String _description;
  late String _imageUrl; // DATA TYPE TO BE DEFINED!
  int _likes = 0;
  int _saves = 0;
  final List<Food> _foodItems = [];
  final List<Review> _reviews = [];

  Restaurant(String name, String location, String phone, String description,
      String image) {
    setName(name);
    setLocation(location);
    setPhone(phone);
    setDescription(description);
    setImageUrl(image);
  }

  factory Restaurant.fromFirebase(String docId, Map<String, dynamic> data) {
    Restaurant restaurant = Restaurant(data["name"], data["location"],
        data["phone"], data["description"], data["imageUrl"]);
    restaurant.setDocId(docId);
    return restaurant;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": _name,
      "location": _location,
      "phone": _phone,
      "description": _description,
      "imageUrl": _imageUrl,
      "likes": _likes,
      "saves": _saves,
      "foodItems": _foodItems
          .where((Food food) => food.getDocId() != null)
          .map((Food food) => food.getDocId()),
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

  String getLocation() {
    return _location;
  }

  void setLocation(String location) {
    if (!validateLocation(location))
      throw ArgumentError("The location is invalid!");
    _location = location;
  }

  String getPhone() {
    return _phone;
  }

  void setPhone(String phone) {
    if (!validatePhone(phone))
      throw ArgumentError("The phone number is invalid!");
    _phone = phone;
  }

  String getDescription() {
    return _description;
  }

  void setDescription(String description) {
    if (!validateDescription(description))
      throw ArgumentError("The description is invalid");
    _description = description;
  }

  String getImageUrl() {
    return _imageUrl;
  }

  void setImageUrl(String image) {
    _imageUrl = image;
  }

  List<Food> getFoodItems() {
    return _foodItems;
  }

  void addFoodItem(Food food) {
    _foodItems.add(food);
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

  static bool validateLocation(String location) {
    if (Utils.hasInvalidSpaces(location)) return false;
    RegExp validLocationRegex = RegExp(r"^.+$");
    return validLocationRegex.hasMatch(location);
  }

  static bool validateDescription(String description) {
    if (Utils.hasInvalidSpaces(description)) return false;
    RegExp validDescriptionRegex =
        RegExp("^[\\p{L}0-9()\\[\\]{}'\"]\$", unicode: true);
    return validDescriptionRegex.hasMatch(description);
  }

  /// Checks the format of the phone number [phone].
  ///
  /// Accepts phone numbers of the format "(ddd) ddd-dddd" where "d" is a digit.
  /// Returns true if valid, false if not.
  static bool validatePhone(String phone) {
    RegExp regex = RegExp(r"^\(\d{3}\) \d{3}-\d{4}$");
    return regex.hasMatch(phone);
  }
}
