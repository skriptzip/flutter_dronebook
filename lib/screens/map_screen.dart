import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/aircraft.dart';
import '../services/location_service.dart';
import '../services/opensky_service.dart';
import '../widgets/aircraft_marker_layer.dart';
import '../widgets/aircraft_detail_sheet.dart';
import '../l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();
  final OpenSkyService _openSkyService = OpenSkyService();
  final TextEditingController _searchController = TextEditingController();

  LatLng? _currentPosition;
  LatLng? _mapCenter;
  bool _isLoading = true;
  bool _showNoFlyZones = true;
  double _flightRadius = 50;
  bool _showFlightRadius = true;
  final bool _showRadiusPanel = false;
  List<GeoLocation> _searchSuggestions = [];
  bool _showSuggestions = false;


  List<Aircraft> _aircraft = [];
  bool _showAircraft = true;
  bool _isLoadingAircraft = false;
  Timer? _aircraftRefreshTimer;
  Timer? _deadReckoningTimer;
  Aircraft? _selectedAircraft;
  int _drVersion = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  @override
  void dispose() {
    _aircraftRefreshTimer?.cancel();
    _deadReckoningTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    final position = await _locationService.getCurrentPosition();
    final resolved = position ?? LatLng(52.5200, 13.4050);
    if (!mounted) return;
    setState(() {
      _currentPosition = resolved;
      _isLoading = false;
    });
    // Defer map movement until FlutterMap widget is fully rendered
    if (position != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(resolved, 13.0);
      });
    }
    if (_showAircraft) {
      await _startAircraftTracking();
    }
  }

  Future<void> _startAircraftTracking() async {
    _aircraftRefreshTimer?.cancel();
    _deadReckoningTimer?.cancel();

    await _fetchAircraft();

    _aircraftRefreshTimer = Timer.periodic(
      OpenSkyService.fetchInterval,
      (_) => _fetchAircraft(),
    );

    _deadReckoningTimer = Timer.periodic(
      OpenSkyService.deadReckoningInterval,
      (_) {
        if (!mounted || _aircraft.isEmpty) return;
        for (final ac in _aircraft) {
          ac.updateDeadReckoning();
        }
        setState(() => _drVersion++);
      },
    );
  }

  void _stopAircraftTracking() {
    _aircraftRefreshTimer?.cancel();
    _aircraftRefreshTimer = null;
    _deadReckoningTimer?.cancel();
    _deadReckoningTimer = null;
  }

  Future<void> _fetchAircraft() async {
    final center = _mapCenter ?? _currentPosition;
    if (center == null) {
      debugPrint('⚠️ _fetchAircraft: Keine Position verfügbar');
      return;
    }

    debugPrint('🛩️ Fetching aircraft at ${center.latitude}, ${center.longitude}');
    
    if (mounted) setState(() => _isLoadingAircraft = true);

    try {
      final fetched = await _openSkyService.fetchAircraft(center);

      if (mounted) {
        setState(() {
          if (fetched != null) {
            _aircraft = fetched;
            debugPrint('✅ Loaded ${fetched.length} aircraft');
          } else {
            debugPrint('⚠️ fetchAircraft returned null');
          }
          _isLoadingAircraft = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error fetching aircraft: $e');
      if (mounted) {
        setState(() => _isLoadingAircraft = false);
      }
    }
  }

  void _showAircraftDetails(Aircraft ac) {
    setState(() => _selectedAircraft = ac);
    showModalBottomSheet(
      context: context,
      builder: (_) => AircraftDetailSheet(aircraft: ac),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ).whenComplete(() {
      if (mounted) setState(() => _selectedAircraft = null);
    });
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _showSuggestions = false);
    try {
      final locations = await _locationService.searchLocation(query);
      if (locations.isNotEmpty && mounted) {
        final location = locations.first;
        final newPosition = LatLng(location.latitude, location.longitude);
        setState(() {
          _currentPosition = newPosition;
          _showFlightRadius = true;
        });
        _mapController.move(newPosition, 14.0);
        _searchController.clear();
        _fetchAircraft();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.positionSet(
              location.latitude.toStringAsFixed(4),
              location.longitude.toStringAsFixed(4),
            )),
          ));
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.addressNotFound)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.searchError(e.toString()))));
      }
    }
  }

  Future<void> _onSearchChanged(String query) async {
    if (query.length < 3) {
      setState(() {
        _searchSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    try {
      final locations = await _locationService.searchLocation(query);
      if (mounted) {
        setState(() {
          _searchSuggestions = locations.take(5).toList();
          _showSuggestions = locations.isNotEmpty;
        });
      }
    } catch (e) {
      debugPrint('Suggestion error: $e');
    }
  }

  void _selectSuggestion(GeoLocation location) {
    final l10n = AppLocalizations.of(context)!;
    final newPosition = LatLng(location.latitude, location.longitude);
    setState(() {
      _currentPosition = newPosition;
      _showFlightRadius = true;
      _showSuggestions = false;
      _searchSuggestions = [];
    });
    _mapController.move(newPosition, 14.0);
    _searchController.clear();
    _fetchAircraft();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l10n.positionSet(
        location.latitude.toStringAsFixed(4),
        location.longitude.toStringAsFixed(4),
      )),
    ));
  }

  void _setPositionFromMap(LatLng position) {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _currentPosition = position;
      _showFlightRadius = true;
    });
    _fetchAircraft();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l10n.positionSet(
        position.latitude.toStringAsFixed(4),
        position.longitude.toStringAsFixed(4),
      )),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mapTitle),
        elevation: 0,
        actions: [
          if (_showAircraft)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: _isLoadingAircraft
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Chip(
                      avatar:
                          const Icon(Icons.airplanemode_active, size: 16),
                      label: Text('${_aircraft.length}'),
                      padding: EdgeInsets.zero,
                    ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [

                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        _currentPosition ?? LatLng(52.5200, 13.4050),
                    initialZoom: 16.0,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture) {
                        _mapCenter = position.center;
                      }
                    },
                    onTap: (_, point) => _setPositionFromMap(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.dronebook.app',
                    ),
                    if (_showFlightRadius && _currentPosition != null)
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: _currentPosition!,
                            radius: _flightRadius,
                            useRadiusInMeter: true,
                            color: Colors.blue.withOpacity(0.2),
                            borderColor: Colors.blue,
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                    if (_showNoFlyZones)
                      TileLayer(
                        urlTemplate:
                            '${SupabaseConfig.supabaseUrl}/functions/v1/nofly-tiles?z={z}&x={x}&y={y}',
                        userAgentPackageName: 'com.dronebook.app',
                        tileProvider: NetworkTileProvider(
                          headers: {
                            'Authorization':
                                'Bearer ${SupabaseConfig.supabaseAnonKey}',
                            'apikey': SupabaseConfig.supabaseAnonKey,
                          },
                        ),
                      ),
                    if (_currentPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentPosition!,
                            width: 80,
                            height: 80,
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    if (_showAircraft)
                      AircraftMarkerLayer(
                        key: ValueKey(_drVersion),
                        aircraft: _aircraft,
                        selectedAircraft: _selectedAircraft,
                        onTap: _showAircraftDetails,
                      ),
                  ],
                ),


                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: l10n.searchHint,
                                    border: InputBorder.none,
                                    icon: const Icon(Icons.search),
                                  ),
                                  onChanged: _onSearchChanged,
                                  onSubmitted: (_) => _searchLocation(),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: _searchLocation,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_showSuggestions && _searchSuggestions.isNotEmpty)
                        Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(top: 4),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _searchSuggestions.length,
                            itemBuilder: (context, index) {
                              final loc = _searchSuggestions[index];
                              return ListTile(
                                dense: true,
                                leading: const Icon(Icons.location_on,
                                    size: 20),
                                title: Text(loc.displayName,
                                    style:
                                        const TextStyle(fontSize: 14)),
                                onTap: () => _selectSuggestion(loc),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),


                if (_showRadiusPanel)
                  Positioned(
                    bottom: 250,
                    right: 16,
                    child: Card(
                      elevation: 4,
                      child: Container(
                        width: 250,
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(l10n.flightRadiusLabel,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                Text(
                                  '${_flightRadius.toStringAsFixed(0)} m',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                            Slider(
                              value: _flightRadius,
                              min: 50,
                              max: 5000,
                              divisions: 99,
                              onChanged: (v) =>
                                  setState(() => _flightRadius = v),
                            ),
                            CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(l10n.radiusShow),
                              value: _showFlightRadius,
                              onChanged: (v) => setState(
                                  () => _showFlightRadius = v ?? false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),


                Positioned(
                  bottom: 100,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'aircraft',
                        mini: true,
                        backgroundColor:
                            _showAircraft ? Colors.red : null,
                        tooltip: _showAircraft
                            ? l10n.hideAircraft
                            : l10n.showAircraft,
                        onPressed: () async {
                          if (_showAircraft) {
                            _stopAircraftTracking();
                            setState(() {
                              _showAircraft = false;
                              _aircraft = [];
                            });
                          } else {
                            setState(() => _showAircraft = true);
                            await _startAircraftTracking();
                          }
                        },
                        child: Icon(_showAircraft
                            ? Icons.airplanemode_active
                            : Icons.airplanemode_inactive),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: 'noflyzone',
                        mini: true,
                        onPressed: () => setState(
                            () => _showNoFlyZones = !_showNoFlyZones),
                        child: Icon(_showNoFlyZones
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: 'location',
                        mini: true,
                        onPressed: _initializeLocation,
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),


                Positioned(
                  bottom: 4,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: Colors.black54,
                    child: const Text(
                      '© OpenAIP | © OpenStreetMap | © OpenSky Network',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/log-flight',
              arguments: _currentPosition);
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.logFlightTitle),
      ),
    );
  }
}