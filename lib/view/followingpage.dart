import 'package:flutter/material.dart';
import 'package:munchit/model/restaurant.dart';
import 'package:munchit/model/user.dart';

class FollowingPage extends StatelessWidget {
  final User user;

  const FollowingPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    List<Restaurant> saved = user.getSavedRestaurants().cast<Restaurant>();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Saved Restaurants",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: saved.isEmpty
              ? const Center(child: Text("No saved restaurants."))
              : ListView.builder(
            itemCount: saved.length,
            itemBuilder: (context, index) {
              final restaurant = saved[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    child: Image(image: restaurant.getImage()), // Placeholder for image
                  ),
                  title: Text(restaurant.getName()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${restaurant.getLocation()}'),
                      Row(
                        children: [
                          Column(
                              children: [
                                IconButton(onPressed: () {},
                                  icon: Icon(Icons.favorite_border),
                                  iconSize: 16,),
                                SizedBox(width: 4),
                                Text('${restaurant.getLikes()}'),
                              ]
                          ),
                          SizedBox(width: 10),
                          Column(
                              children: [
                                IconButton(onPressed: () {},
                                  icon: Icon(Icons.request_page),
                                  iconSize: 16,),
                                SizedBox(width: 4),
                                Text('${restaurant.getSaves()}'),
                              ]
                          ),
                          SizedBox(width: 10),
                          Column(
                              children: [
                                IconButton(onPressed: () {},
                                  icon: Icon(Icons.comment),
                                  iconSize: 16,),
                                SizedBox(width: 4),
                                Text('${restaurant.getReviews().length}'),
                              ]
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.star, size: 16),
                          SizedBox(width: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}