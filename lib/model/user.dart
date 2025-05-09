import 'package:bcrypt/bcrypt.dart';
import 'package:munchit/model/restaurant.dart';
import 'food.dart';
import 'review.dart';

/// User class is used to represent a user of the application.
class User {
  String? _docId;
  late String _userName;
  late String _email;
  late String _phone;
  late List<Restaurant> _likedRestaurants;
  late List<Restaurant> _savedRestaurants;
  late List<Restaurant> _createdRestaurants;
  late List<Food> _createdFoods;
  late List<Review> _createdReviews;
  UserSettings settings =
      UserSettings(); // Make the settings public for easier access
  String? _passwordHash;

  User._(
      this._docId,
      this._userName,
      this._email,
      this._phone,
      this._likedRestaurants,
      this._savedRestaurants,
      this._createdRestaurants,
      this._createdFoods,
      this._createdReviews,
      this.settings,
      this._passwordHash);

  /// Constructor used when creating a user that does not exist on the
  /// database.
  ///
  /// Throws [ArgumentError] if any of the provided arguments is of an
  /// incorrect format according to their respective validation methods.
  User.withPassword(
      String userName, String email, String phone, String password) {
    // Set all values
    setUserName(userName);
    setEmail(email);
    setPhone(phone);
    setPasswordHash(password);
    settings = UserSettings(); // Default settings
    _likedRestaurants = [];
    _savedRestaurants = [];
    _createdRestaurants = [];
    _createdFoods = [];
    _createdReviews = [];
  }

  factory User.fromFirebase(String docId, Map<String, dynamic> data) => User._(
      docId,
      data["username"],
      data["email"],
      data["phone"],
      data["likedRestaurants"],
      data["savedRestaurants"],
      data["createdRestaurants"],
      data["createdFoods"],
      data["createdReviews"],
      UserSettings.fromFirebase(data["settings"]),
      data["passwordHash"]);

  Map<String, dynamic> toMap() {
    // Convert associations into lists of IDs and store those.
    return {
      "username": _userName,
      "email": _email,
      "phone": _phone,
      "likedRestaurants": _likedRestaurants
          .where((Restaurant r) => r.getDocId() != null)
          .map((Restaurant r) => r.getDocId()),
      "savedRestaurants": _savedRestaurants
          .where((Restaurant r) => r.getDocId() != null)
          .map((Restaurant r) => r.getDocId()),
      "createdRestaurants": _createdRestaurants
          .where((Restaurant r) => r.getDocId() != null)
          .map((Restaurant r) => r.getDocId()),
      "createdFoods": _createdFoods
          .where((Food f) => f.getDocId() != null)
          .map((Food f) => f.getDocId()),
      "createdReviews": _createdReviews
          .where((Review r) => r.getDocId() != null)
          .map((Review r) => r.getDocId()),
      "settings": settings.toMap(),
      "passwordHash": _passwordHash,
    };
  }

  /// Getter for the user id.
  ///
  /// Returns the id of the user or null if the user does not have an id.
  String? getDocId() {
    return _docId;
  }

  /// Setter for the user id.
  void setDocId(String docId) {
    _docId = docId;
  }

  /// Getter for the user's username.
  ///
  /// Returns the username of the user.
  String getUserName() {
    return _userName;
  }

  /// Setter for the user's username.
  ///
  /// Throws an [ArgumentError] if the username is of incorrect format according
  /// to the [validateUserName] method.
  void setUserName(String userName) {
    // Validate username
    if (!validateUserName(userName)) {
      throw ArgumentError("The username is invalid!");
    }
    _userName = userName;
  }

  /// Getter for the user's email.
  ///
  /// Returns the email of the user.
  String getEmail() {
    return _email;
  }

  /// Setter for the user's email.
  ///
  /// Throws an [ArgumentError] if the email is of incorrect format according
  /// to the [validateEmail] method.
  void setEmail(String email) {
    // Validate email
    if (!validateEmail(email)) {
      throw ArgumentError("The email is invalid!");
    }
    _email = email;
  }

  /// Getter for the user's phone.
  ///
  /// Returns the phone number of the user.
  String getPhone() {
    return _phone;
  }

  /// Setter for the user's phone.
  ///
  /// Throws an [ArgumentError] if the phone number is of incorrect
  /// format according to the [validatePhone] method.
  void setPhone(String phone) {
    // Validate phone
    if (!validatePhone(phone)) {
      throw ArgumentError("The phone number is invalid!");
    }
    _phone = phone;
  }

  void addLikedRestaurant(Restaurant restaurant) {
    _likedRestaurants.add(restaurant);
  }

  /// Getter for the user's liked restaurants.
  ///
  /// Returns the list of the liked restaurants of the user.
  List<Restaurant> getLikedRestaurants() {
    return _likedRestaurants;
  }

  void addSavedRestaurant(Restaurant restaurant) {
    _savedRestaurants.add(restaurant);
  }

  /// Getter for the user's saved restaurants.
  ///
  /// Returns the list of the saved restaurants of the user.
  List<Restaurant> getSavedRestaurants() {
    return _savedRestaurants;
  }

  void addCreatedRestaurant(Restaurant restaurant) {
    _createdRestaurants.add(restaurant);
  }

  /// Getter for the user's created restaurants.
  ///
  /// Returns the list of the created restaurants of the user.
  List<Restaurant> getCreatedRestaurants() {
    return _createdRestaurants;
  }

  void addCreatedFood(Food food) {
    _createdFoods.add(food);
  }

  /// Getter for the user's created foods.
  ///
  /// Returns the list of the created foods of the user.
  List<Food> getCreatedFoods() {
    return _createdFoods;
  }

  void addCreatedReview(Review review) {
    _createdReviews.add(review);
  }

  /// Getter for the user's created reviews.
  ///
  /// Returns the list of the created reviews of the user.
  List<Review> getCreatedReviews() {
    return _createdReviews;
  }

  /// Compare a [password] with the current user's password.
  ///
  /// Throws an [ArgumentError] if the password is of invalid format.
  /// Returns true if passwords match, false if not.
  bool comparePassword(String password) {
    if (!validatePassword(password)) {
      throw ArgumentError("The password is invalid!");
    }
    return BCrypt.checkpw(password, _passwordHash!);
  }

  /// Setter for a user's password.
  ///
  /// Hashes the password is of valid format, and throws an [ArgumentError] if
  /// not.
  void setPasswordHash(String password) {
    // Validate password
    if (!validatePassword(password)) {
      throw ArgumentError("The password is invalid!");
    }
    // Hash the password
    _passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Checks the format of the username [userName].
  ///
  /// Accepts usernames with alphanumeric characters only.
  /// Returns true if valid, false if not.
  static bool validateUserName(String userName) {
    RegExp regex = RegExp(r"^[\w]+$");
    return regex.hasMatch(userName);
  }

  /// Checks the format of the email [email].
  ///
  /// Accepts emails as defined by the HTML specifications.
  /// Returns true if valid, false if not.
  static bool validateEmail(String email) {
    // Regex taken from https://html.spec.whatwg.org/multipage/input.html#e-mail-state-%28type=email%29
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(email);
  }

  /// Checks the format of the phone number [phone].
  ///
  /// Accepts phone numbers of the format "(ddd) ddd-dddd" where "d" is a digit.
  /// Returns true if valid, false if not.
  static bool validatePhone(String phone) {
    RegExp regex = RegExp(r"^\(\d{3}\) \d{3}-\d{4}$");
    return regex.hasMatch(phone);
  }

  /// Checks the format of the password [password].
  ///
  /// Accepts passwords from 8 to 50 characters which include the following
  /// characters: alphanumeric characters, and '! @ # $ % ^ & * () {} [] - + ='.
  /// Returns true if valid, false if not.
  static bool validatePassword(String password) {
    RegExp regex = RegExp(r"^[\w!@#$%^&*(){}\-=+\[\]]{8,50}$");
    return regex.hasMatch(password);
  }
}

/// UserSettings class is used to represent the app settings of a user.
class UserSettings {
  late bool _isDarkMode;
  late bool _enabledNotifications;
  late bool _enabledLocationServices;

  /// Default constructor that can accept any settings.
  UserSettings(
      {bool isDarkMode = false,
      bool enabledNotifications = false,
      bool enabledLocation = false}) {
    _isDarkMode = isDarkMode;
    _enabledNotifications = enabledNotifications;
    _enabledLocationServices = enabledLocation;
  }

  factory UserSettings.fromFirebase(Map<String, dynamic> data) => UserSettings(
      isDarkMode: data["isDarkMode"],
      enabledNotifications: data["enabledNotifications"],
      enabledLocation: data["enabledLocationServices"]);

  Map<String, bool> toMap() {
    return {
      "isDarkMode": _isDarkMode,
      "enabledNotifications": _enabledNotifications,
      "enabledLocationServices": _enabledLocationServices
    };
  }

  /// Toggle dark mode from true to false and vice versa.
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
  }

  /// Toggle enabled notifications from true to false and vice versa.
  void toggleNotifications() {
    _enabledNotifications = !_enabledNotifications;
  }

  /// Toggle enabled location services from true to false and vice versa.
  void toggleLocationServices() {
    _enabledLocationServices = !_enabledLocationServices;
  }

  /// Getter for _isDarkMode.
  bool isDarkModeEnabled() {
    return _isDarkMode;
  }

  /// Getter _enabledNotifications.
  bool areNotificationsEnabled() {
    return _enabledNotifications;
  }

  /// Getter for _enabledLocationServices.
  bool areLocationServicesEnabled() {
    return _enabledLocationServices;
  }
}
