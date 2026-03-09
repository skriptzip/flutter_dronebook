import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/aircraft.dart';

IconData aircraftIcon(Aircraft ac) {
  if (ac.isUAV) return Icons.connecting_airports;
  if (ac.isHelicopter) return Icons.air;
  if (ac.onGround) return Icons.airplanemode_inactive;
  return Icons.airplanemode_active;
}

Color aircraftColor(Aircraft ac) {
  if (ac.isUAV) return Colors.orange;
  if (ac.isHelicopter) return Colors.purple;
  if (ac.onGround) return Colors.grey;
  return Colors.red;
}

class AircraftMarkerLayer extends StatelessWidget {
  final List<Aircraft> aircraft;
  final Aircraft? selectedAircraft;
  final void Function(Aircraft) onTap;

  const AircraftMarkerLayer({
    super.key,
    required this.aircraft,
    required this.onTap,
    this.selectedAircraft,
  });

  @override
  Widget build(BuildContext context) {
    final markers = aircraft
        .where((ac) => ac.displayLatitude != null && ac.displayLongitude != null)
        .map((ac) {
      final isSelected = selectedAircraft?.icao24 == ac.icao24;
      return Marker(
        point: LatLng(ac.displayLatitude!, ac.displayLongitude!),
        width: isSelected ? 48 : 36,
        height: isSelected ? 48 : 36,
        child: GestureDetector(
          onTap: () => onTap(ac),
          child: Transform.rotate(
            angle: ac.trueTrack != null ? (ac.trueTrack! * 3.14159265 / 180.0) : 0,
            child: Icon(
              aircraftIcon(ac),
              color: isSelected ? Colors.yellow : aircraftColor(ac),
              size: isSelected ? 36 : 28,
              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
        ),
      );
    }).toList();

    return MarkerLayer(markers: markers);
  }
}