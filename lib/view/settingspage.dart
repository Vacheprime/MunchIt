import 'package:flutter/material.dart';
import 'package:munchit/view/aboutuspage.dart';

import '../model/user.dart';

class Settings extends StatefulWidget {
  final User user;

  const Settings({super.key, required this.user});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkMode = false;
  bool isNotification = false;
  bool isLocation = false;

  @override
  void initState() {
    super.initState();
    isNotification = widget.user.settings.areNotificationsEnabled();
    isDarkMode = widget.user.settings.isDarkModeEnabled();
    isLocation = widget.user.settings.areLocationServicesEnabled();
  }
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
                      widget.user.settings.toggleDarkMode(); // Toggle the setting
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
                  value: isNotification,
                  onChanged:  (value) async {
                    setState(() {
                      isNotification = value!;
                    });
                    if (value == true) {
                      await widget.user.settings.requestNotificationPermissions();
                    } else {
                      widget.user.settings.toggleNotifications();
                    }
                    setState(() {
                      isNotification = widget.user.settings.areNotificationsEnabled();
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
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs(user: widget.user,)));
              },
              child: const Text(
                'About Us',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}