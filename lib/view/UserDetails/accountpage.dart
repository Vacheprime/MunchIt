import 'package:flutter/material.dart';
import 'package:munchit/view/UserDetails/changepasswordpage.dart';
import 'package:munchit/view/UserDetails/userstatspage.dart';
import '../../model/User.dart';
import '../settingspage.dart';

class Account extends StatefulWidget {
  final User user;

  const Account({super.key, required this.user});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController username = TextEditingController();
  bool isEditing = false;

  void initState() {
    super.initState();
    username = TextEditingController(text: widget.user.getUserName());
  }

  @override
  void dispose() {
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color.fromRGBO(248, 145, 145, 1)),
              child: const Center(
                  child: Text("Options", style: TextStyle(fontSize: 24))),
            ),
            ListTile(
              title: Text("• Account"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Account(user: widget.user)));
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings(user: widget.user)));
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        leading: IconButton(onPressed: () {
              () => _scaffoldKey.currentState?.openDrawer();
        }, icon: Icon(Icons.menu)),
        title: Text("Munch't"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back))
        ],
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
                  controller: username,
                  readOnly: !isEditing,
                  decoration: InputDecoration(
                    labelText: "${widget.user.getUserName()}",
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChangePassword(user: widget.user,)));
          },
          child: Text(
            "Change Password",
            style: TextStyle(color: Color.fromRGBO(248, 145, 145, 1)),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
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
}
