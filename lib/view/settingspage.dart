import 'package:flutter/material.dart';
import 'package:munchit/services/geolocation_service/geolocation_service.dart';
import 'package:munchit/services/repositories/user_repository.dart';
import 'package:munchit/view/aboutuspage.dart';

import '../model/user.dart';

class Settings extends StatefulWidget {
  final User user;

  const Settings({super.key, required this.user});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late UserSettings settings = UserSettings();

  @override
  void initState() {
    super.initState();
    settings = widget.user.settings;
  }

  Future<void> _updateUser() async {
    UserRepository repository = UserRepository();
    repository.update(widget.user);
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
                  value: settings.isDarkModeEnabled(),
                  onChanged: (value) async {
                    setState(() {
                      settings.toggleDarkMode(); // Toggle the setting
                    });
                    await _updateUser();
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
                  value: settings.areNotificationsEnabled(),
                  onChanged:  (value) async {
                    setState(() {
                      settings.toggleNotifications();
                    });
                    if (value == true) {
                      await widget.user.settings.requestNotificationPermissions();
                    }
                    await _updateUser();
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
                  value: settings.areLocationServicesEnabled(),
                  onChanged: (value) async {
                    if (value != null) {
                      await _toggleLocationServices(value);
                    }
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

  Future<void> _toggleLocationServices(bool value) async {
    bool permissionGranted = await GeolocationService.requestLocationPermissions();
    if (permissionGranted) {
      setState(() {
        settings.toggleLocationServices();
      });
      await _updateUser();
    }
  }
}