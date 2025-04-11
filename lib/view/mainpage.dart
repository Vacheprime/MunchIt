import 'package:flutter/material.dart';

import '../model/User.dart';

class MainPage extends StatefulWidget {
  const MainPage(User user);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(248, 145, 145, 1),
      ),
    );
  }
}
