import 'package:flutter/material.dart';
import 'package:munchit/view/UserDetails/userstatspage.dart';

import '../../model/user.dart';
import '../settingspage.dart';
import 'accountpage.dart';

class ChangePassword extends StatefulWidget {
  final User user;

  const ChangePassword({super.key, required this.user});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController current = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration:
              BoxDecoration(color: Color.fromRGBO(248, 145, 145, 1)),
              child: Center(
                  child: Text("Options", style: TextStyle(fontSize: 24))),
            ),
            ListTile(
              title: Text("• Account"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Account(user: widget.user)));
              },
            ),
            ListTile(
              title: Text("• Your Stats"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Stats(user: widget.user)));
              },
            ),
            ListTile(
              title: Text("• Settings"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Settings(user: widget.user)));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(248, 145, 145, 1),
        title: Text("Munch't"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Change Password", style: TextStyle(fontSize: 24)),
              SizedBox(height: 25),
              TextField(
                controller: current,
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  labelText: "Current Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrent = !_obscureCurrent;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: newPassword,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: "New Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility_off : Icons
                          .visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: confirmPassword,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons
                          .visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 35),
              ElevatedButton(
                onPressed: () {
                  if (!widget.user.comparePassword(current.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Current password is incorrect")),
                    );
                    return;
                  }
                  if (newPassword.text != confirmPassword.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("New passwords do not match")),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Password changed successfully")),
                  );
                    widget.user.setPasswordHash(newPassword.text);
                    current.clear();
                    newPassword.clear();
                    confirmPassword.clear();
                },
                child: Text(
                  "Change",
                  style: TextStyle(color: Color.fromRGBO(248, 145, 145, 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}