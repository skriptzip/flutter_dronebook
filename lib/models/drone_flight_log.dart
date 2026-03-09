class DroneFlightLog {
  final String? id;
  final String title;
  final String droneName;
  final String droneModel;
  final double startLatitude;
  final double startLongitude;
  final String? address; // Adresse des Startorts
  final double? endLatitude;
  final double? endLongitude;
  final DateTime startTime;
  final DateTime? endTime;
  final double? maxAltitude;
  final double? flightDuration; // in minutes
  final double? flightRadius; // in meters
  final String? notes;
  final List<String>? weatherConditions; // TEXT[] in Supabase
  final double? windSpeed; // in km/h
  final String? pilotName;

  DroneFlightLog({
    this.id,
    required this.title,
    required this.droneName,
    required this.droneModel,
    required this.startLatitude,
    required this.startLongitude,
    this.address,
    this.endLatitude,
    this.endLongitude,
    required this.startTime,
    this.endTime,
    this.maxAltitude,
    this.flightDuration,
    this.flightRadius,
    this.notes,
    this.weatherConditions,
    this.windSpeed,
    this.pilotName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'drone_name': droneName,
      'drone_model': droneModel,
      'start_latitude': startLatitude,
      'start_longitude': startLongitude,
      'address': address,
      'end_latitude': endLatitude,
      'end_longitude': endLongitude,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'max_altitude': maxAltitude,
      'flight_duration': flightDuration,
      'flight_radius': flightRadius,
      'notes': notes,
      'weather_conditions': weatherConditions, // List → TEXT[]
      'wind_speed': windSpeed,
      'pilot_name': pilotName,
    };
  }

  factory DroneFlightLog.fromJson(Map<String, dynamic> json) {
    return DroneFlightLog(
      id: json['id'] as String?,
      title: json['title'] as String,
      droneName: json['drone_name'] as String,
      droneModel: json['drone_model'] as String,
      startLatitude: (json['start_latitude'] as num).toDouble(),
      startLongitude: (json['start_longitude'] as num).toDouble(),
      address: json['address'] as String?,
      endLatitude: json['end_latitude'] != null
          ? (json['end_latitude'] as num).toDouble()
          : null,
      endLongitude: json['end_longitude'] != null
          ? (json['end_longitude'] as num).toDouble()
          : null,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      maxAltitude: json['max_altitude'] != null
          ? (json['max_altitude'] as num).toDouble()
          : null,
      flightDuration: json['flight_duration'] != null
          ? (json['flight_duration'] as num).toDouble()
          : null,
      flightRadius: json['flight_radius'] != null
          ? (json['flight_radius'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
      weatherConditions: json['weather_conditions'] != null
          ? List<String>.from(json['weather_conditions'] as List)
          : null,
      windSpeed: json['wind_speed'] != null
          ? (json['wind_speed'] as num).toDouble()
          : null,
      pilotName: json['pilot_name'] as String?,
    );
  }
}