import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:munchit/model/restaurant.dart';
import 'package:munchit/model/user.dart';
import 'package:munchit/services/api/places_api_service.dart';
import 'package:munchit/services/geolocation_service/geolocation.dart';
import 'package:munchit/services/geolocation_service/geolocation_service.dart';
import 'package:munchit/services/repositories/restaurant_repository.dart';
import 'package:munchit/services/repositories/user_repository.dart';

class CreateRestaurant extends StatefulWidget {
  final User user;

  const CreateRestaurant({super.key, required this.user});

  @override
  State<CreateRestaurant> createState() => _CreateRestaurantState();
}

class _CreateRestaurantState extends State<CreateRestaurant> {
  static final Geolocation defaultLocation =
      Geolocation(lat: 45.492, long: -73.658);
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();
  PlaceDetails? placeDetails;

  String? imagePath;

  Future<void> _findRestaurant() async {
    // Search by address or name
    String address = _addressController.text;
    String name = _nameController.text;
    if (address.isEmpty && name.isEmpty) {
      return;
    }

    // Initialize places
    PlacesApiService placesService = PlacesApiService();
    await placesService.initialize();
    // Check if location services are enabled
    List<PlacesSearchResult> placesResults;
    // Determine the location to use for searching
    Geolocation locationSearch;
    if (await GeolocationService.isLocationServicesAllowed()) {
      locationSearch = await GeolocationService.getCurrentLocation();
    } else {
      locationSearch = defaultLocation;
    }

    // Get default results
    if (address.isNotEmpty) {
      placesResults = await placesService
          .findRestaurantsNearby(locationSearch, 10000, address: address);
    } else {
      placesResults = await placesService
          .findRestaurantsNearby(locationSearch, 10000, name: name);
    }
    // Check if there are any results
    if (placesResults.isEmpty) {
      _showSnackBar("Restaurant not found!", 200);
      return;
    }
    // Set the details
    placeDetails =
        await placesService.getRestaurantDetails(placesResults[0].placeId);
    if (placeDetails == null) {
      _showSnackBar("Could not fetch restaurant details!", 200);
      return;
    }
    // Set information
    _nameController.text = placeDetails!.name;
    _addressController.text = placeDetails!.formattedAddress!;
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = Color.fromRGBO(248, 145, 145, 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: buildTextField("Restaurant Name", _nameController)),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor,
                ),
                onPressed: _findRestaurant,
                child:
                    const Text("Find", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          buildTextField("Address", _addressController),
          buildTextField("Phone", _phoneController),
          buildTextField("Description", _descController, maxLines: 5),
          buildTextField("Image", _imageController),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkColor,
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: _createRestaurant,
            child: const Text("Add", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller,
      {int maxLines = 1}) {
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

  bool _validateInput() {
    String phone = _phoneController.text;
    String description = _descController.text;
    String imageUrl = _imageController.text;
    bool isValid = true;
    if (!Restaurant.validatePhone(phone)) {
      _showSnackBar("The phone number is invalid!", 200);
      isValid = false;
    } else if (!Restaurant.validateDescription(description)) {
      _showSnackBar("The description is invalid!", 200);
      isValid = false;
    } else if (imageUrl.isEmpty) {
      _showSnackBar("The image url is invalid!", 200);
      isValid = false;
    }
    return isValid;
  }

  Future<void> _createRestaurant() async {
    if (placeDetails == null) {
      _showSnackBar("You must find a restaurant using the find button!", 300);
      return;
    }
    if (!_validateInput()) {
      return;
    }
    String name = placeDetails!.name;
    String address = placeDetails!.formattedAddress!;
    String phone = _phoneController.text;
    String description = _descController.text;
    String imageUrl = _imageController.text;
    // Get the geolocation
    Location location = placeDetails!.geometry!.location;
    Geolocation geoLocation = Geolocation(lat: location.lat, long: location.lng);
    // Create the restaurant
    Restaurant restaurant = Restaurant(name, address, phone, description, imageUrl, geoLocation);
    // Insert the restaurant
    RestaurantRepository repository = RestaurantRepository();
    await repository.add(restaurant);
    // Add restaurant to user and update
    User user = widget.user;
    user.addCreatedRestaurant(restaurant);
    UserRepository userRepository = UserRepository();
    await userRepository.update(user);
    _showSnackBar("Restaurant successfully created!", 300);
    _clearForm();
  }

  void _clearForm() {
    placeDetails = null;
    _nameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _descController.clear();
    _imageController.clear();
  }

  /// Show a SnackBar with a custom message and width.
  void _showSnackBar(String message, double width) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Center(child: Text(message)),
        width: width,
        behavior: SnackBarBehavior.floating,
      ));
  }
}
