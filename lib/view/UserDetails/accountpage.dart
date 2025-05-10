import 'package:flutter/material.dart';
import 'package:munchit/services/repositories/user_repository.dart';
import 'package:munchit/view/Login/homepage.dart';
import 'package:munchit/view/UserDetails/changepasswordpage.dart';
import 'package:munchit/view/UserDetails/userstatspage.dart';
import '../../model/user.dart';
import '../settingspage.dart';

class Account extends StatefulWidget {
  final User user;

  const Account({super.key, required this.user});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  bool isEditing = false;

  void initState() {
    super.initState();
    username = TextEditingController(text: widget.user.getUserName());
    email = TextEditingController(text: widget.user.getEmail());
    phone = TextEditingController(text: widget.user.getPhone());
  }

  @override
  void dispose() {
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(248, 145, 145, 1),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("Munch't"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text("Account", style: TextStyle(fontSize: 24)),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: email,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: phone,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: username,
                      readOnly: !isEditing,
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(isEditing ? Icons.check : Icons.edit),
                    onPressed: () {
                      setState(() {
                        if (isEditing) {
                          //update functionality from firebase
                        }
                        isEditing = !isEditing;
                      });
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePassword(
                              user: widget.user,
                            )));
              },
              child: Text(
                "Change Password",
                style: TextStyle(color: Color.fromRGBO(248, 145, 145, 1)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: Text(
                "Log out",
                style: TextStyle(color: Color.fromRGBO(248, 145, 145, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    UserRepository userRepository = UserRepository();
    await userRepository.eraseCredentials();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
        (route) => false);
  }
}
