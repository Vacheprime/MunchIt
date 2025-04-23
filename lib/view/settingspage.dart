import 'package:flutter/material.dart';
import 'package:munchit/view/aboutuspage.dart';

import '../model/User.dart';

class Settings extends StatefulWidget {
  final User user;

  const Settings({super.key, required this.user});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkMode = false;
  bool isNotifaction = false;
  bool isLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Munch't"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(248, 145, 145, 1),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Settings", style: TextStyle(fontSize: 48)),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Dark Mode",  style: TextStyle(fontSize: 24)),
                SizedBox(width: 20),
                Checkbox(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value!;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Notifications",  style: TextStyle(fontSize: 24)),
                SizedBox(width: 20),
                Checkbox(
                  value: isNotifaction,
                  onChanged: (value) {
                    setState(() {
                      isNotifaction = value!;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Location",  style: TextStyle(fontSize: 24)),
                SizedBox(width: 20),
                Checkbox(
                  value: isLocation,
                  onChanged: (value) {
                    setState(() {
                      isLocation = value!;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Location",  style: TextStyle(fontSize: 24)),
                SizedBox(width: 20),
                Checkbox(
                  value: isLocation,
                  onChanged: (value) {
                    setState(() {
                      isLocation = value!;
                    });
                  },
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs(user: widget.user,)));
              },
              child: Text(
                'About Us',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () {
              //save functionality
            }, child: Text("Save"))
          ],
        ),
      ),
    );
  }
}