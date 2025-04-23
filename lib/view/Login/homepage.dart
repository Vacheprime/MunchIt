import 'package:flutter/material.dart';
import 'package:munchit/view/Login/loginpage.dart';
import 'package:munchit/view/Login/registerpage.dart';
import 'package:munchit/view/settingspage.dart';
import 'registerpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(248, 145, 145, 1),
        title: Text("Munch't"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Discover New Restaurants"),
            Image.network(""),
            Text("Trattoria Bella Vita"),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            }, child: Text("Login"), ),

            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
            }, child: Text("Register"), ),
          ],
        )
      ),
    );
  }
}
