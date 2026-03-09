import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/aircraft.dart';

class OpenSkyService {
  static const double bbox = 0.9;
  static const Duration fetchInterval = Duration(seconds: 15);
  static const Duration deadReckoningInterval = Duration(seconds: 2);

  bool _fetchInProgress = false;

  Future<List<Aircraft>?> fetchAircraft(LatLng center) async {
    if (_fetchInProgress) return null;
    _fetchInProgress = true;

    final lat = center.latitude;
    final lon = center.longitude;

    final uri = Uri.parse(
      'https://opensky-network.org/api/states/all'
      '?lamin=${(lat - bbox).toStringAsFixed(6)}'
      '&lomin=${(lon - bbox).toStringAsFixed(6)}'
      '&lamax=${(lat + bbox).toStringAsFixed(6)}'
      '&lomax=${(lon + bbox).toStringAsFixed(6)}'
      '&extended=1',
    );

    try {
      final response =
          await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final states = data['states'] as List<dynamic>?;

        final List<Aircraft> result = [];
        if (states != null) {
          for (final state in states) {
            try {
              final ac = Aircraft.fromStateVector(state as List<dynamic>);
              if (ac.latitude != null && ac.longitude != null) {
                result.add(ac);
              }
            } catch (_) {}
          }
        }
        return result;
      } else if (response.statusCode == 429) {
        debugPrint('OpenSky: Rate limit (429) – alte Liste behalten');
      } else {
        debugPrint('OpenSky: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('OpenSky fetch error: $e');
    } finally {
      _fetchInProgress = false;
    }

    return null;
  }
}