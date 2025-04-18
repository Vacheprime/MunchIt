import 'package:flutter/material.dart';
import 'package:munchit/model/User.dart';

class CreateRestaurant extends StatefulWidget {
  final User user;

  const CreateRestaurant({super.key, required this.user});

  @override
  State<CreateRestaurant> createState() => _CreateRestaurantState();
}

class _CreateRestaurantState extends State<CreateRestaurant> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descController = TextEditingController();

  String? imagePath;

  @override
  Widget build(BuildContext context) {
    final pinkColor = Colors.pink[200];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          buildTextField("Restaurant Name", _nameController),
          Row(
            children: [
              Expanded(child: buildTextField("Address", _addressController)),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor,
                ),
                onPressed: () {
                  // Add your "Find" logic here
                },
                child: const Text("Find", style: TextStyle(color: Colors.black)),
              )
            ],
          ),
          buildTextField("Phone", _phoneController),
          buildTextField("Description", _descController, maxLines: 5),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Image", style: TextStyle(fontSize: 16)),
              const SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor,
                ),
                onPressed: () {
                  // Add image picker logic here
                },
                child: const Text("Select", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkColor,
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () {
              // Add form submission logic here
            },
            child: const Text("Add", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}