import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class GeoLocation {
  final double latitude;
  final double longitude;
  final String displayName;

  GeoLocation({
    required this.latitude,
    required this.longitude,
    required this.displayName,
  });
}

class LocationService {

  Future<bool> checkAndRequestPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled =
        await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<LatLng?> getCurrentPosition() async {
    try {
      final hasPermission =
          await checkAndRequestPermissions();

      if (!hasPermission) return null;

      final position =
          await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LatLng(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  Future<List<GeoLocation>> searchLocation(
      String query) async {
    try {
      final uri = Uri.parse(
        "https://nominatim.openstreetmap.org/search"
        "?q=$query"
        "&format=json"
        "&addressdetails=1"
        "&limit=5",
      );

      final response = await http.get(
        uri,
        headers: {
          "User-Agent": "dronebook-app",
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Geocoding failed");
      }

      final List data =
          jsonDecode(response.body);

      return data.map((item) {
        return GeoLocation(
          latitude:
              double.parse(item["lat"]),
          longitude:
              double.parse(item["lon"]),
          displayName:
              item["display_name"],
        );
      }).toList();
    } catch (e) {
      print('Error searching location: $e');
      return [];
    }
  }

  Future<String?> getAddressFromCoordinates(
      double lat, double lng) async {
    try {
      final uri = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse"
        "?lat=$lat"
        "&lon=$lng"
        "&format=json",
      );

      final response = await http.get(
        uri,
        headers: {
          "User-Agent": "dronebook-app",
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data =
          jsonDecode(response.body);

      return data["display_name"];
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings:
          const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}