import 'package:flutter/material.dart';
import 'package:munchit/model/restaurant.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/geolocation_service/geolocation_service.dart';
import 'package:munchit/services/repositories/restaurant_repository.dart';
import 'package:munchit/view/Restaurant/restaurantpage.dart';
import 'package:munchit/view/UserDetails/accountpage.dart';
import 'package:munchit/view/UserDetails/userstatspage.dart';
import 'package:munchit/view/settingspage.dart';
import '../services/geolocation_service/geolocation.dart' show Geolocation;
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

  Stream<List<Restaurant>>? restaurantStream;

  Future<void> _getSuggestedRestaurants() async {
    // Get the user
    User user = widget.user;
    // Suggested choice
    bool suggestByLocation = false;
    if (user.settings.areLocationServicesEnabled()) {
      if (!await GeolocationService.isLocationServicesAllowed()) {
        if (await GeolocationService.requestLocationPermissions()) {
          suggestByLocation = true;
        }
      }
    }
    RestaurantRepository repository = RestaurantRepository();
    // Suggest by location if allowed
    if (suggestByLocation) {
      Geolocation position = await GeolocationService.getCurrentLocation();
      restaurantStream = repository.getRestaurantsNearby(position, 5);
    } else {
      // Suggest random
      restaurantStream = repository.withLimit(15).retrieve().asStream();
    }
  }

  Widget _buildRestaurantListing() {
    return StreamBuilder(
      stream: restaurantStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<Restaurant> restaurants = snapshot.data!;
        return Expanded(
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
                    child: Image.network(restaurant.getImageUrl())),
                title: Text(restaurant.getName()),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(restaurant.getAddress()),
                    Row(
                      children: [
                        Column(children: [
                          IconButton(
                            onPressed: () {
                              //increase the like count of the restaurant
                              //change the heart to a solid red one
                              //add it to the user's like list
                            },
                            icon: Icon(Icons.favorite_border),
                            iconSize: 16,
                          ),
                          SizedBox(width: 4),
                          Text(restaurant.getLikes().toString()),
                        ]),
                        SizedBox(width: 10),
                        Column(children: [
                          IconButton(
                            onPressed: () {
                              //increase the save count of the restaurant
                              //change the save to a solid yellow one
                              //add it to the user's saved/favourite list
                            },
                            icon: Icon(Icons.request_page),
                            iconSize: 16,
                          ),
                          SizedBox(width: 4),
                          Text(restaurant.getSaves().toString()),
                        ]),
                        SizedBox(width: 10),
                        Column(children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RestaurantInfo(
                                          user: widget.user,
                                          restaurant: restaurant)));
                            },
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
        ));
      },
    );
  }

  Widget buildSuggestedPage() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    // Dropdown box to be added here with the filtered (price and location?)
                    // and change the colour when a filter is applied
                  }),
            ),
          ),
        ),
        FutureBuilder(
            future: _getSuggestedRestaurants(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return _buildLoadingIndicator();
              }
              return _buildRestaurantListing();
            })
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      child: Container(
        height: 100,
        width: 100,
        child: CircularProgressIndicator(),
      ),
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
            const DrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromRGBO(248, 145, 145, 1)),
              child: const Center(
                  child: Text("Munch't", style: TextStyle(fontSize: 24))),
            ),
            ListTile(
              title: Text("• Account"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Account(user: widget.user)));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Settings(user: widget.user)));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(248, 145, 145, 1),
        title: Text("Munch't"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
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
        backgroundColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() {
              _previousIndex = _currentIndex;
              _currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Suggested"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Following"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Create"),
        ],
      ),
    );
  }
}
