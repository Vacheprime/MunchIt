import 'dart:convert';
import 'dart:io';

import 'package:flutter_google_maps_webservices/places.dart';

class PlacesApiService {
  static const String apiKeyFile = "google_places_api_key.json";
  late final GoogleMapsPlaces _places;

  PlacesApiService() {
    _loadFromApiKeyFile();
  }

  Future<List<PlacesSearchResult>> findRestaurantsNearby(Location location, int radius, {String? name, String? address}) async {
    if (name == null && address == null) {
      throw ArgumentError("The name or the address must be specified.");
    }
    String query = address ?? name!;
    return (await _places.searchNearbyWithRadius(location, radius, name: query, type: "restaurant")).results;
  }

  Future<PlaceDetails?> getRestaurantDetails(String placeId) async {
    PlacesDetailsResponse detailsResponse = await _places.getDetailsByPlaceId(placeId);
    if (detailsResponse.hasNoResults) {
      return null;
    }
    return detailsResponse.result;
  }

  void _loadFromApiKeyFile() {
    File file = File("lib/services/api/config/$apiKeyFile");
    try {
      String apiKeyText = file.readAsStringSync();
      Map<String, dynamic> keyJson = jsonDecode(apiKeyText);
      String key = keyJson["PlaceAPIKey"];
      _places = GoogleMapsPlaces(apiKey: key);
    } catch (e) {
      print("Error read Places API Key file. ${e.toString()}");
      rethrow;
    }
  }
}
