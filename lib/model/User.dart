
class User {
  int id;
  String username;
  String email;
  String phone;
  String password;
  Map<String, dynamic> settings;

  User ({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.settings,
  });
}