import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/drone_flight_log.dart';
import '../services/supabase_service.dart';
import '../l10n/app_localizations.dart';

class FlightLogsScreen extends StatefulWidget {
  const FlightLogsScreen({super.key});

  @override
  State<FlightLogsScreen> createState() => _FlightLogsScreenState();
}

class _FlightLogsScreenState extends State<FlightLogsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<DroneFlightLog> _flightLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFlightLogs();
  }

  Future<void> _loadFlightLogs() async {
    setState(() => _isLoading = true);
    final logs = await _supabaseService.getFlightLogs();
    if (mounted) {
      setState(() {
        _flightLogs = logs;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteFlightLog(String id) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteFlightLogTitle),
        content: Text(l10n.deleteFlightLogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _supabaseService.deleteFlightLog(id);
      if (success && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.flightLogDeleted)));
        _loadFlightLogs();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.flightLogsTitle),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadFlightLogs),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _flightLogs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.flight_takeoff, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(l10n.noLogsTitle,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(l10n.noLogsSubtitle),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _flightLogs.length,
                  itemBuilder: (context, index) {
                    final log = _flightLogs[index];
                    return _buildLogCard(log, l10n);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/log-flight');
          _loadFlightLogs();
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.newFlightButton),
      ),
    );
  }

  Widget _buildLogCard(DroneFlightLog log, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: const Icon(Icons.flight),
        title: Text(
          log.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${log.droneName}  ·  ${DateFormat('dd.MM.yyyy HH:mm').format(log.startTime)}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteFlightLog(log.id!),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(log.startLatitude, log.startLongitude),
                        initialZoom: 14.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.dronebook.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(log.startLatitude, log.startLongitude),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on,
                                  color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (log.address != null && log.address!.isNotEmpty)
                  _buildDetailRow(l10n.addressLabel, log.address!),

                _buildDetailRow(l10n.droneRegistrationId, log.droneName),
                _buildDetailRow(l10n.modelLabel, log.droneModel),

                if (log.pilotName != null)
                  _buildDetailRow(l10n.pilotLabel, log.pilotName!),

                _buildDetailRow(
                  l10n.coordinatesLabel,
                  '${log.startLatitude.toStringAsFixed(4)}, '
                  '${log.startLongitude.toStringAsFixed(4)}',
                ),

                if (log.maxAltitude != null)
                  _buildDetailRow(
                    l10n.maxAltitudeLabel,
                    '${log.maxAltitude!.toStringAsFixed(1)} m',
                  ),

                if (log.flightRadius != null)
                  _buildDetailRow(
                    l10n.flightRadius,
                    '${log.flightRadius!.toStringAsFixed(0)} m',
                  ),

                if (log.endTime != null)
                  _buildDetailRow(
                    l10n.endTimeLabel,
                    DateFormat('dd.MM.yyyy HH:mm').format(log.endTime!),
                  ),

                if (log.flightDuration != null)
                  _buildDetailRow(
                    l10n.durationLabel,
                    '${log.flightDuration!.toStringAsFixed(0)} min',
                  ),

                if (log.weatherConditions != null &&
                    log.weatherConditions!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildWeatherRow(l10n.weatherLabel, log.weatherConditions!),
                ],

                if (log.windSpeed != null)
                  _buildDetailRow(
                    l10n.windspeedLabel2,
                    '${log.windSpeed!.toStringAsFixed(1)} ${l10n.windSpeedUnit}',
                  ),

                if (log.notes != null)
                  _buildDetailRow(l10n.notesLabel, log.notes!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildWeatherRow(String label, List<String> conditions) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: conditions
                  .map((c) => Chip(
                        label: Text(c, style: const TextStyle(fontSize: 12)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}