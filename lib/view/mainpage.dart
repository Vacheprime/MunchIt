import 'package:flutter/material.dart';
import 'package:munchit/model/Restaurant.dart';

import '../model/User.dart';

class MainPage extends StatefulWidget {
  const MainPage(User user);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchQuery = '';
  List<Restaurant> restaurants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink[200]),
              child: Center(child: Text("Options", style: TextStyle(fontSize: 24))),
            ),
            ListTile(title: Text("• Account")),
            ListTile(title: Text("• Your Stats")),
            ListTile(title: Text("• Settings")),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: const Text("Munch't"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Add filter dialog here (e.g., rating & distance)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300], // Placeholder for image
                    ),
                    title: Text('Title Here'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location here'),
                        Row(
                          children: [
                            Icon(Icons.favorite_border, size: 16),
                            SizedBox(width: 4),
                            Text('123'),
                            SizedBox(width: 10),
                            Icon(Icons.comment, size: 16),
                            SizedBox(width: 4),
                            Text('45'),
                            SizedBox(width: 10),
                            Icon(Icons.star, size: 16),
                            SizedBox(width: 4),
                            Text('4.5'),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation to Suggested / Following / Create
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Suggested"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Following"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Create"),
        ],
      ),
    );
  }
}