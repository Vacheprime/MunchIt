import 'food.dart';
import 'package:munchit/services/utils/utils.dart';

/// Restaurant class os used to represent a restaurant in the application.
class Restaurant {
  String? _docId;
  late String _name;
  late String _location;
  late String _phone;
  late String _description;
  late String _image; // DATA TYPE TO BE DEFINED!
  int _likes = 0;
  int _saves = 0;
  final List<Food> _foodItems = [];
  final List<String> _reviewDocIds = [];

  Restaurant(String name, String location, String phone, String description, String image) {
    setName(name);
    setLocation(location);
    setPhone(phone);
    setDescription(description);
    setImage(image);
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
    if (!validateLocation(location)) throw ArgumentError("The location is invalid!");
    _location = location;
  }

  String getPhone() {
    return _phone;
  }

  void setPhone(String phone) {
    if (!validatePhone(phone)) throw ArgumentError("The phone number is invalid!");
    _phone = phone;
  }

  String getDescription() {
    return _description;
  }

  void setDescription(String description) {
    if (!validateDescription(description)) throw ArgumentError("The description is invalid");
    _description = description;
  }

  String getImage() {
    return _image;
  }

  void setImage(String image) {
    _image = image;
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

  List<String> getReviewDocIds() {
    return _reviewDocIds;
  }

  void addReviewDocId(String reviewDocId) {
    _reviewDocIds.add(reviewDocId);
  }

  void removeReviewDocId(String reviewDocId) {
    _reviewDocIds.remove(reviewDocId);
  }

  static bool validateName(String name) {
    if (Utils.hasInvalidSpaces(name)) return false;
    RegExp validNameRegex = RegExp(r"^[\p{L} ]+$", unicode: true);
    return validNameRegex.hasMatch(name);
  }

  static bool validatePrice(double price) {
    return price > 0;
  }

  static bool validateLocation(String location) {
    if (Utils.hasInvalidSpaces(location)) return false;
    RegExp validLocationRegex = RegExp(r"^.+$");
    return validLocationRegex.hasMatch(location);
  }

  static bool validateDescription(String description) {
    if (Utils.hasInvalidSpaces(description)) return false;
    RegExp validDescriptionRegex = RegExp("^[\\p{L}0-9()\\[\\]{}'\"]\$", unicode: true);
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