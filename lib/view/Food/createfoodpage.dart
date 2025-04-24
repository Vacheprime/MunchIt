import 'package:flutter/material.dart';
import '../../model/user.dart';

class CreateFood extends StatefulWidget {
  final User user;

  const CreateFood({super.key, required this.user});

  @override
  State<CreateFood> createState() => _CreateFoodState();
}

class _CreateFoodState extends State<CreateFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(),
    );
  }
}
