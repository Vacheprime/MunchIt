import 'package:flutter/material.dart';

import '../../model/User.dart';

class Account extends StatefulWidget {
  final User user;

  const Account({super.key, required this.user});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
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
          children: [
            Text("Account")
          ],
        ),
      ),
    );
  }
}
