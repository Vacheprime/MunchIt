import 'package:flutter/material.dart';
import 'package:munchit/model/Restaurant.dart';
import 'package:munchit/model/User.dart';
import 'package:munchit/view/UserDetails/accountpage.dart';
import 'package:munchit/view/UserDetails/userstatspage.dart';
import 'package:munchit/view/settingspage.dart';
import 'followingpage.dart';
import 'Restaurant/createrestaurantpage.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage(this.user, {super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  int _previousIndex = 0;

  String searchQuery = '';
  List<Restaurant> restaurants = [];

  Widget buildSuggestedPage() {
    return Column(
      children: [
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
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: Container(
                      width: 60,
                      height: 60,
                      child: Image(image: restaurant.getImage())),
                  title: Text('${restaurant.getName()}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${restaurant.getLocation()}'),
                      Row(
                        children: [
                          Column(children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.favorite_border),
                              iconSize: 16,
                            ),
                            SizedBox(width: 4),
                            Text('${restaurant.getLikes()}'),
                          ]),
                          SizedBox(width: 10),
                          Column(children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.request_page),
                              iconSize: 16,
                            ),
                            SizedBox(width: 4),
                            Text('${restaurant.getSaves()}'),
                          ]),
                          SizedBox(width: 10),
                          Column(children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.comment),
                              iconSize: 16,
                            ),
                            SizedBox(width: 4),
                            Text('${restaurant.getReviews().length}'),
                          ]),
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      buildSuggestedPage(),
      FollowingPage(user: widget.user, key: const ValueKey("FollowingPage")),
      CreateRestaurant(
          user: widget.user, key: const ValueKey("CreateRestaurantPage")),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink[200]),
              child: const Center(
                  child: Text("Options", style: TextStyle(fontSize: 24))),
            ),
            ListTile(
              title: Text("• Account"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Account(user: widget.user)));
              },
            ),
            ListTile(
              title: Text("• Your Stats"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Stats(user: widget.user)));
              },
            ),
            ListTile(
              title: Text("• Settings"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: const Text("Munch't"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Dropdown box to be added here with the filtered (price and location?)
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          final inFromRight = _currentIndex > _previousIndex;
          final offsetAnimation = Tween<Offset>(
            begin: Offset(inFromRight ? 1 : -1, 0),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() {
              _previousIndex = _currentIndex;
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Suggested"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Following"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Create"),
        ],
      ),
    );
  }
}
