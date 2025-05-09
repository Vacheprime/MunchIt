import 'package:flutter/material.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/exceptions/FirestoreInsertException.dart';
import 'package:munchit/services/repositories/user_repository.dart';
import 'package:munchit/view/mainpage.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _isPassObscured = true;
  bool _isConfirmedPassObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: const Color.fromRGBO(248, 145, 145, 1),
        centerTitle: true,
        title: const Text("Munch't"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Register",
              style: TextStyle(fontSize: 36),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone (xxx) xxx-xxxx',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: _isPassObscured,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPassObscured ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _togglePassObscure,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: _isConfirmedPassObscured,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmedPassObscured
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: _toggleConfirmPassObscure,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text("Register"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(248, 145, 145, 1),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Toggle password visibility for password field.
  void _togglePassObscure() {
    setState(() {
      _isPassObscured = !_isPassObscured;
    });
  }

  /// Toggle password visibility for confirm password field.
  void _toggleConfirmPassObscure() {
    setState(() {
      _isConfirmedPassObscured = !_isConfirmedPassObscured;
    });
  }

  /// Validate field data.
  /// This method shows snack bars indicating which fields are invalid.
  ///
  /// Returns a [bool] indicating whether the text fields all have valid data.
  bool _validateFieldData() {
    bool isValid = true;
    // Validate the password
    if (!User.validateUserName(usernameController.text)) {
      isValid = false;
      _showSnackBar("The username must contain letters and digits only!", 350);
    } else if (!User.validateEmail(emailController.text)) {
      isValid = false;
      _showSnackBar("The email entered is invalid!", 250);
    } else if (!User.validatePhone(phoneController.text)) {
      isValid = false;
      _showSnackBar("The phone number must be of format (XXX) XXX-XXXX!", 300);
    } else if (!User.validatePassword(passwordController.text)) {
      isValid = false;
      _showSnackBar("The password must contain at least 8 characters!", 350);
    } else if (passwordController.text != confirmPasswordController.text) {
      isValid = false;
      _showSnackBar("The passwords do not match!", 225);
    }
    return isValid;
  }

  /// Register a new user.
  Future<void> _registerUser() async {
    // Validate user input
    if (!_validateFieldData()) return;

    // Create the user
    String userName = usernameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    User user = User.withPassword(userName, email, phone, password);

    UserRepository repository = UserRepository();
    // Check if the username has been taken
    if (await repository.isUserNameTaken(userName)) {
      _showSnackBar("The username has already been taken!", 300);
      return;
    }
    // Attempt to insert the user
    try {
      await repository.add(user);
    } catch (e) {
      if (e is FirestoreInsertException) {
        _showSnackBar("Error inserting user: ${e.message}", 400);
      } else {
        // Rethrow exception that couldn't be handled.
        rethrow;
      }
    }
    // Go to main page
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MainPage(user)));
  }

  /// Show a SnackBar with a custom message and width.
  void _showSnackBar(String message, double width) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Center(child: Text(message)),
        width: width,
        behavior: SnackBarBehavior.floating,
      ));
  }
}
