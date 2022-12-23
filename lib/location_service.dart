import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<Position?> getLocation() async {
    Position? position;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse ||
          permission != LocationPermission.always) {}
    }
    bool locationService = await Geolocator.isLocationServiceEnabled();
    if (!locationService) {
      await Geolocator.openLocationSettings();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }

    return position;
  }

  static Future<Placemark> getAddressFromCoordinates(
    double lat,
    double long,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        lat,
        long,
      );
      return placemarks.first;
    } catch (e) {
      rethrow;
    }
  }
}
