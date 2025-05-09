import 'package:geolocator/geolocator.dart';

class GeolocationService {
  static const List<LocationPermission> deniedPermissions = [LocationPermission.denied, LocationPermission.deniedForever, LocationPermission.unableToDetermine];
  static const List<LocationPermission> allowedPermission = [LocationPermission.always, LocationPermission.whileInUse];

  static Future<bool> isLocationServicesAllowed() async {
    // Check if location service is allowed
    if (! await Geolocator.isLocationServiceEnabled()) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (deniedPermissions.contains(permission)) {
      return false;
    }
    return true;
  }

  static Future<bool> requestLocationPermissions() async {
    // Check if location service is enabled
    if (! await Geolocator.isLocationServiceEnabled()) {
      return false;
    }
    // Check if permission already granted
    LocationPermission permission = await Geolocator.checkPermission();
    if (allowedPermission.contains(permission)) {
      return true;
    }
    // Request permissions
    permission = await Geolocator.requestPermission();
    return allowedPermission.contains(permission);
  }


}