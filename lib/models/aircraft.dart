import 'dart:math' as math;

class Aircraft {
  final String icao24;
  final String? callsign;
  final String? originCountry;
  final double? longitude;
  final double? latitude;
  final double? baroAltitude;
  final bool onGround;
  final double? velocity; // m/s
  final double? trueTrack;
  final int category;

  double? displayLatitude;
  double? displayLongitude;
  DateTime fetchedAt;

  Aircraft({
    required this.icao24,
    this.callsign,
    this.originCountry,
    this.longitude,
    this.latitude,
    this.baroAltitude,
    required this.onGround,
    this.velocity,
    this.trueTrack,
    required this.category,
    DateTime? fetchedAt,
  })  : fetchedAt = fetchedAt ?? DateTime.now(),
        displayLatitude = latitude,
        displayLongitude = longitude;

  factory Aircraft.fromStateVector(List<dynamic> state) {
    return Aircraft(
      icao24: state[0] as String? ?? '',
      callsign: (state[1] as String?)?.trim(),
      originCountry: state[2] as String?,
      longitude: (state[5] as num?)?.toDouble(),
      latitude: (state[6] as num?)?.toDouble(),
      baroAltitude: (state[7] as num?)?.toDouble(),
      onGround: state[8] as bool? ?? false,
      velocity: (state[9] as num?)?.toDouble(),
      trueTrack: (state[10] as num?)?.toDouble(),
      category: state.length > 17 ? (state[17] as int? ?? 0) : 0,
    );
  }

  bool get isUAV => category == 14;
  bool get isHelicopter => category == 8;

  void updateDeadReckoning() {
    if (onGround ||
        latitude == null ||
        longitude == null ||
        velocity == null ||
        velocity! <= 0 ||
        trueTrack == null) {
      displayLatitude = latitude;
      displayLongitude = longitude;
      return;
    }

    final dt = DateTime.now().difference(fetchedAt).inMilliseconds / 1000.0;
    const earthRadius = 6371000.0;
    const deg2rad = math.pi / 180.0;
    const rad2deg = 180.0 / math.pi;

    final distanceM = velocity! * dt * 0.45;
    final trackRad = trueTrack! * deg2rad;
    final latRad = latitude! * deg2rad;

    final dLat = (distanceM / earthRadius) * rad2deg * math.cos(trackRad);
    final dLon = (distanceM / earthRadius) * rad2deg *
        math.sin(trackRad) / math.cos(latRad);

    displayLatitude = latitude! + dLat;
    displayLongitude = longitude! + dLon;
  }
}