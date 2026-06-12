import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<void> requestPermission() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw Exception("Location services disabled");

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    if (perm == LocationPermission.deniedForever) {
      throw Exception("Permission denied forever");
    }
  }

  static Stream<Position> locationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    );
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      return null;
    }
  }
}