import 'package:latlong2/latlong.dart';

class NoFlyZone {
  final String? id;
  final String name;
  final String type; // airport, military, restricted, etc.
  final List<LatLng> boundaries;
  final String? description;
  final double? maxAltitude; // meters

  NoFlyZone({
    this.id,
    required this.name,
    required this.type,
    required this.boundaries,
    this.description,
    this.maxAltitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'boundaries': boundaries
          .map((point) => {'lat': point.latitude, 'lng': point.longitude})
          .toList(),
      'description': description,
      'max_altitude': maxAltitude,
    };
  }

  factory NoFlyZone.fromJson(Map<String, dynamic> json) {
    final boundariesList = json['boundaries'] as List;
    final boundaries = boundariesList
        .map((point) => LatLng(point['lat'] as double, point['lng'] as double))
        .toList();

    return NoFlyZone(
      id: json['id'] as String?,
      name: json['name'] as String,
      type: json['type'] as String,
      boundaries: boundaries,
      description: json['description'] as String?,
      maxAltitude: json['max_altitude'] != null
          ? (json['max_altitude'] as num).toDouble()
          : null,
    );
  }
}
