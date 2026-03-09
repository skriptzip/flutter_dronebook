import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/drone_flight_log.dart';
import '../models/no_fly_zone.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<DroneFlightLog>> getFlightLogs() async {
    try {
      final response = await _client
          .from('flight_logs')
          .select()
          .order('start_time', ascending: false);

      return (response as List)
          .map((json) => DroneFlightLog.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching flight logs: $e');
      return [];
    }
  }

  Future<bool> addFlightLog(DroneFlightLog log) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        print('Error adding flight log: User not authenticated');
        return false;
      }
      
      final logData = log.toJson();
      logData.remove('id');
      logData['user_id'] = userId;
      
      print('Inserting flight log with user_id: $userId');
      await _client.from('flight_logs').insert(logData);
      return true;
    } catch (e) {
      print('Error adding flight log: $e');
      return false;
    }
  }

  Future<bool> updateFlightLog(DroneFlightLog log) async {
    try {
      await _client.from('flight_logs').update(log.toJson()).eq('id', log.id!);
      return true;
    } catch (e) {
      print('Error updating flight log: $e');
      return false;
    }
  }

  Future<bool> deleteFlightLog(String id) async {
    try {
      await _client.from('flight_logs').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting flight log: $e');
      return false;
    }
  }

  Future<List<NoFlyZone>> getNoFlyZones() async {
    try {
      final response = await _client.from('no_fly_zones').select();

      return (response as List)
          .map((json) => NoFlyZone.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching no-fly zones: $e');
      return [];
    }
  }

  Future<bool> addNoFlyZone(NoFlyZone zone) async {
    try {
      await _client.from('no_fly_zones').insert(zone.toJson());
      return true;
    } catch (e) {
      print('Error adding no-fly zone: $e');
      return false;
    }
  }
}
