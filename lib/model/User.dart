
class User {
  int id;
  String username;
  String email;
  String phone;
  String password;
  UserSettings settings;

  User ({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.settings,
  });
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