import 'dart:math';

import 'package:flutter/material.dart';
import 'package:munchit/model/restaurant.dart';
import 'package:munchit/services/repositories/restaurant_repository.dart';
import 'package:munchit/view/Login/loginpage.dart';
import 'package:munchit/view/Login/registerpage.dart';

/// Homepage is the homepage where users can register or log in.
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Restaurant? discoverRestaurant;

  @override
  void initState() {
    super.initState();
  }

  Future<Restaurant> _getRandomRestaurant() async {
    // Get the restaurant repository
    RestaurantRepository repository = RestaurantRepository();
    // Get the restaurants
    List<Restaurant> restaurants = await repository.withLimit(5).retrieve();
    // Get one random
    int randomIndex = Random().nextInt(restaurants.length);
    return restaurants[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(248, 145, 145, 1),
        title: const Text(
          "Munch't",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Discover New Restaurants",
              style: TextStyle(fontSize: 28),
            ),
            _buildNewRestaurantBanner(),
            _buildLoginButtons(),
            const SizedBox(height: 10,) // Used to center the login buttons
          ],
        ),
      )),
    );
  }

  Column _buildLoginButtons() {
    return Column(
      spacing: 10,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: const Text("Login"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Register()));
          },
          child: const Text("Register"),
        ),
      ],
    );
  }

  FutureBuilder _buildNewRestaurantBanner() {
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _getRandomRestaurant(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        // Get the restaurant
        Restaurant restaurant = snapshot.data!;
        return Column(
          children: [
            // Clip R Rect used for rounded borders.
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(restaurant.getImageUrl(),
                  width: screenWidth - 50, fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return const CircularProgressIndicator();
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                restaurant.getName(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            )
          ],
        );
      },
    );
  }
}
