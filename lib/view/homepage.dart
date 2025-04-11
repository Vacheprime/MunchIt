import 'package:flutter/material.dart';
import 'package:munchit/view/loginpage.dart';
import 'package:munchit/view/settingspage.dart';
import 'mainpage.dart';

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
        backgroundColor: Colors.pink[100],
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
          }, icon: Icon(Icons.settings))
        ],
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
            }, child: Text("Login"), )
          ],
        )
      ),
    );
  }
}
