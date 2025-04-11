import 'package:bcrypt/bcrypt.dart';

class User {
  String? _id;
  late String _userName;
  late String _email;
  late String _phone;
  late String _passwordHash;
  // Make the settings public for easier access
  late UserSettings settings;

  User(String userName, String email, String phone, String password) {
    // Set all values
    setUserName(userName);
    setEmail(email);
    setPhone(phone);
    setPasswordHash(password);
    settings = UserSettings();
  }

  String? getId() {
    return _id;
  }

  void setId(String id) {
    _id = id;
  }

  String getUserName() {
    return _userName;
  }

  void setUserName(String userName) {
    // Validate username
    if (!validateUserName(userName)) {
      throw ArgumentError("The username is invalid!");
    }
    _userName = userName;
  }

  String getEmail(String email) {
    return _email;
  }

  void setEmail(String email) {
    // Validate email
    if (!validateEmail(email)) {
      throw ArgumentError("The email is invalid!");
    }
    _email = email;
  }

  String getPhone() {
    return _phone;
  }

  void setPhone(String phone) {
    // Validate phone
    if (!validatePhone(phone)) {
      throw ArgumentError("The phone number is invalid!");
    }
    _phone = phone;
  }

  bool comparePassword(String password) {
    String hash = BCrypt.hashpw(password, BCrypt.gensalt());
    return BCrypt.checkpw(password, _passwordHash);
  }

  void setPasswordHash(String password) {
    // Validate password
    if (!validatePassword(password)) {
      throw ArgumentError("The password is invalid!");
    }
    // Hash the password
    _passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
  }

  static bool validateUserName(String userName) {
    RegExp regex = RegExp(r"^[\w]+$");
    return regex.hasMatch(userName);
  }

  static bool validateEmail(String email) {
    // Regex taken from https://html.spec.whatwg.org/multipage/input.html#e-mail-state-%28type=email%29
    RegExp regex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(email);
  }

  static bool validatePhone(String phone) {
    RegExp regex = RegExp(r"^\(\d{3}\) \d{3}-\d{4}$");
    return regex.hasMatch(phone);
  }

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
  UserSettings({bool isDarkMode = false, bool enabledNotifications = false, bool enabledLocation = false}) {
    _isDarkMode = isDarkMode;
    _enabledNotifications = enabledNotifications;
    _enabledLocationServices = enabledLocation;
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