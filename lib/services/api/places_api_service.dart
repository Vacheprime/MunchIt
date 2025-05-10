import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:munchit/services/geolocation_service/geolocation.dart';

class PlacesApiService {
  static const String apiKeyAsset = "lib/services/api/config/google_places_api_key.json";
  late final GoogleMapsPlaces _places;

  PlacesApiService();

  Future<void> initialize() async {
    await _loadApiKeyFromAsset();
  }

  /// Radius in meters
  Future<List<PlacesSearchResult>> findRestaurantsNearby(
      Geolocation location, int radius,
      {String? name, String? address}) async {
    if (name == null && address == null) {
      throw ArgumentError("The name or the address must be specified.");
    }
    String query = address ?? name!;
    return (await _places.searchNearbyWithRadius(
            Location(lat: location.lat, lng: location.long), radius,
            name: query, type: "restaurant"))
        .results;
  }

  Future<PlaceDetails?> getRestaurantDetails(String placeId) async {
    PlacesDetailsResponse detailsResponse =
        await _places.getDetailsByPlaceId(placeId);
    if (detailsResponse.hasNoResults) {
      return null;
    }
    return detailsResponse.result;
  }

  Future<void> _loadApiKeyFromAsset() async {
    String apiKeyText = await rootBundle.loadString(apiKeyAsset);
    try {
      Map<String, dynamic> keyJson = jsonDecode(apiKeyText);
      String key = keyJson["PlaceAPIKey"];
      _places = GoogleMapsPlaces(apiKey: key);
    } catch (e) {
      print("Error read Places API Key file. ${e.toString()}");
      rethrow;
    }
  }
}
