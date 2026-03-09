import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/drone_flight_log.dart';
import '../services/location_service.dart';
import '../services/supabase_service.dart';
import '../l10n/app_localizations.dart';

class _WeatherOption {
  final String key;
  final IconData icon;
  final Color color;

  const _WeatherOption({
    required this.key,
    required this.icon,
    required this.color,
  });
}

const _weatherOptions = [
  _WeatherOption(key: 'sunny', icon: Icons.wb_sunny, color: Colors.orange),
  _WeatherOption(key: 'partlyCloudy', icon: Icons.wb_cloudy, color: Colors.blueGrey),
  _WeatherOption(key: 'cloudy', icon: Icons.cloud, color: Colors.grey),
  _WeatherOption(key: 'overcast', icon: Icons.cloud_queue, color: Colors.grey),
  _WeatherOption(key: 'lightRain', icon: Icons.grain, color: Colors.lightBlue),
  _WeatherOption(key: 'rain', icon: Icons.umbrella, color: Colors.blue),
  _WeatherOption(key: 'thunderstorm', icon: Icons.thunderstorm, color: Colors.deepPurple),
  _WeatherOption(key: 'snow', icon: Icons.ac_unit, color: Colors.cyan),
  _WeatherOption(key: 'fog', icon: Icons.foggy, color: Colors.blueGrey),
  _WeatherOption(key: 'windy', icon: Icons.air, color: Colors.teal),
];

String _getWeatherLabel(BuildContext context, String key) {
  final l10n = AppLocalizations.of(context)!;
  switch (key) {
    case 'sunny':
      return l10n.weatherSunny;
    case 'partlyCloudy':
      return l10n.weatherPartlyCloudy;
    case 'cloudy':
      return l10n.weatherCloudy;
    case 'overcast':
      return l10n.weatherOvercast;
    case 'lightRain':
      return l10n.weatherLightRain;
    case 'rain':
      return l10n.weatherRain;
    case 'thunderstorm':
      return l10n.weatherThunderstorm;
    case 'snow':
      return l10n.weatherSnow;
    case 'fog':
      return l10n.weatherFog;
    case 'windy':
      return l10n.weatherWindy;
    default:
      return key;
  }
}

class _DroneEntry {
  final String kennung;
  final String modell;

  const _DroneEntry({required this.kennung, required this.modell});

  @override
  bool operator ==(Object other) =>
      other is _DroneEntry && other.kennung == kennung && other.modell == modell;

  @override
  int get hashCode => Object.hash(kennung, modell);
}

class LogFlightScreen extends StatefulWidget {
  final double flightRadius;

  const LogFlightScreen({
    super.key,
    this.flightRadius = 50.0,
  });

  @override
  State<LogFlightScreen> createState() => _LogFlightScreenState();
}

class _LogFlightScreenState extends State<LogFlightScreen> {
  final _formKey = GlobalKey<FormState>();
  final LocationService _locationService = LocationService();
  final SupabaseService _supabaseService = SupabaseService();

  final TextEditingController _flightTitleController = TextEditingController();
  final TextEditingController _droneKennungController = TextEditingController();
  final TextEditingController _droneModellController = TextEditingController();
  final TextEditingController _pilotNameController = TextEditingController();
  final TextEditingController _maxAltitudeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _weatherCustomController = TextEditingController();
  final TextEditingController _windSpeedController = TextEditingController();

  DateTime _startTime = DateTime.now();
  DateTime? _endTime;
  double? _startLat;
  double? _startLng;

  late double _flightRadius;

  bool _isLoading = false;
  bool _useManualLocation = false;
  String? _address;

  final MapController _mapController = MapController();

  double get _zoomForRadius {
    const maxEffectiveRadius = 550.0;

    final r = _flightRadius.clamp(0.0, maxEffectiveRadius);

    final z = 17.5 - math.log(r / 50) / math.ln2;

    return z.clamp(10.0, 18.0);
  }

  List<_DroneEntry> _knownDrones = [];
  bool _loadingDrones = false;

  List<String> _knownPilots = [];
  bool _loadingPilots = false;

  final Set<String> _selectedWeather = {};
  bool _showCustomWeather = false;

  List<String>? get _weatherConditionsValue {
    final parts = <String>[];
    for (final key in _selectedWeather) {
      parts.add(_getWeatherLabel(context, key));
    }
    final custom = _weatherCustomController.text.trim();
    if (custom.isNotEmpty) parts.add(custom);
    return parts.isEmpty ? null : parts;
  }

  String? get _weatherPreview {
    final parts = <String>[];
    if (_weatherConditionsValue != null) {
      parts.add(_weatherConditionsValue!.join(', '));
    }
    final wind = _windSpeedController.text.trim();
    if (wind.isNotEmpty) parts.add('Wind: $wind km/h');
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  void initState() {
    super.initState();
    _flightRadius = widget.flightRadius;
    _initializeLocation();
    _loadKnownDrones();
    _loadKnownPilots();
  }

  Future<void> _loadKnownDrones() async {
    setState(() => _loadingDrones = true);
    try {
      final response = await Supabase.instance.client
          .from('flight_logs')
          .select('drone_name, drone_model')
          .order('created_at', ascending: false);

      final entries = <_DroneEntry>{};
      for (final row in response as List<dynamic>) {
        final kennung = row['drone_name'] as String? ?? '';
        final modell = row['drone_model'] as String? ?? '';
        if (kennung.isNotEmpty && modell.isNotEmpty) {
          entries.add(_DroneEntry(kennung: kennung, modell: modell));
        }
      }
      if (mounted) {
        setState(() {
          _knownDrones = entries.toList();
          _loadingDrones = false;
        });
      }
    } catch (e) {
      debugPrint('Fehler beim Laden der Drohnen: $e');
      if (mounted) setState(() => _loadingDrones = false);
    }
  }

  Future<void> _loadKnownPilots() async {
    setState(() => _loadingPilots = true);
    try {
      final response = await Supabase.instance.client
          .from('flight_logs')
          .select('pilot_name')
          .not('pilot_name', 'is', null)
          .order('created_at', ascending: false);

      final pilots = <String>{};
      for (final row in response as List<dynamic>) {
        final name = row['pilot_name'] as String? ?? '';
        if (name.isNotEmpty) pilots.add(name);
      }
      if (mounted) {
        setState(() {
          _knownPilots = pilots.toList();
          _loadingPilots = false;
        });
      }
    } catch (e) {
      debugPrint('Fehler beim Laden der Piloten: $e');
      if (mounted) setState(() => _loadingPilots = false);
    }
  }

  List<String> _filteredPilots(String query) {
    if (query.isEmpty) return _knownPilots;
    final q = query.toLowerCase();
    return _knownPilots.where((p) => p.toLowerCase().contains(q)).toList();
  }

  List<_DroneEntry> _filteredDrones(String query) {
    if (query.isEmpty) return _knownDrones;
    final q = query.toLowerCase();
    return _knownDrones
        .where((d) =>
            d.kennung.toLowerCase().contains(q) ||
            d.modell.toLowerCase().contains(q))
        .toList();
  }

  void _selectDrone(_DroneEntry drone) {
    _droneKennungController.text = drone.kennung;
    _droneModellController.text = drone.modell;
  }

  Future<void> _loadAddress() async {
    if (_startLat == null || _startLng == null) return;
    final address = await _locationService.getAddressFromCoordinates(
      _startLat!,
      _startLng!,
    );
    if (!mounted) return;
    setState(() => _address = address);

    if (_startLat != null && _startLng != null) {
      _mapController.move(
        LatLng(_startLat!, _startLng!),
        _zoomForRadius,
      );
    }
  }

  Future<void> _initializeLocation() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is Map) {
        final position = args['position'] as LatLng?;
        final radius = args['radius'] as double?;
        if (position != null) {
          setState(() {
            _startLat = position.latitude;
            _startLng = position.longitude;
            _useManualLocation = true;
          });
        } else {
          _getCurrentLocation();
        }
        if (radius != null) {
          setState(() => _flightRadius = radius);
        }
      } else if (args is LatLng) {
        setState(() {
          _startLat = args.latitude;
          _startLng = args.longitude;
          _useManualLocation = true;
        });
      } else {
        _getCurrentLocation();
      }

      if (_startLat != null) _loadAddress();
    });
  }

  Future<void> _getCurrentLocation() async {
    final position = await _locationService.getCurrentPosition();
    if (position != null && mounted) {
      setState(() {
        _startLat = position.latitude;
        _startLng = position.longitude;
        _useManualLocation = false;
      });
      _loadAddress();
    }
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartTime) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartTime ? _startTime : (_endTime ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isStartTime ? _startTime : (_endTime ?? DateTime.now()),
        ),
      );
      if (pickedTime != null && mounted) {
        setState(() {
          final dt = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute,
          );
          if (isStartTime) {
            _startTime = dt;
          } else {
            _endTime = dt;
          }
        });
      }
    }
  }

  Future<void> _saveFlightLog() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    if (_startLat == null || _startLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.locationNotAvailable)),
      );
      return;
    }

    setState(() => _isLoading = true);

    final flightLog = DroneFlightLog(
      title: _flightTitleController.text.trim(),
      droneName: _droneKennungController.text.trim(),
      droneModel: _droneModellController.text.trim(),
      startLatitude: _startLat!,
      startLongitude: _startLng!,
      address: _address,
      startTime: _startTime,
      endTime: _endTime,
      maxAltitude: double.tryParse(_maxAltitudeController.text),
      flightDuration: _endTime?.difference(_startTime).inMinutes.toDouble(),
      flightRadius: _flightRadius,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      weatherConditions: _weatherConditionsValue,
      windSpeed: _windSpeedController.text.trim().isEmpty
          ? null
          : double.tryParse(_windSpeedController.text.trim()),
      pilotName: _pilotNameController.text.isEmpty ? null : _pilotNameController.text,
    );

    final success = await _supabaseService.addFlightLog(flightLog);
    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.flightLogSaved)));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.flightLogSaveFailed)));
      }
    }
  }

  Widget _buildMapPreview(ColorScheme colorScheme, AppLocalizations l10n) {
    return Card(
      color: _useManualLocation
          ? colorScheme.primaryContainer
          : colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _useManualLocation ? Icons.location_on : Icons.gps_fixed,
                  color: _useManualLocation
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _useManualLocation ? l10n.manualPosition : l10n.gpsPosition,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.radar, size: 14, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        '${_flightRadius.toStringAsFixed(0)} m',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${_startLat!.toStringAsFixed(6)}, ${_startLng!.toStringAsFixed(6)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 2),
            Text(
              _address ?? 'Adresse wird geladen…',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.gps_fixed, size: 16),
              label: Text(l10n.gpsUpdate),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.radar, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Text(l10n.flightRadius,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Text(
                  '${_flightRadius.toStringAsFixed(0)} m',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.blue.withOpacity(0.2),
                thumbColor: Colors.blue,
                overlayColor: Colors.blue.withOpacity(0.15),
              ),
              child: Slider(
                value: _flightRadius.clamp(10.0, 500.0),
                min: 10,
                max: 500,
                divisions: 49,
                onChanged: (value) {
                  setState(() => _flightRadius = value);
                  if (_startLat != null && _startLng != null) {
                    _mapController.move(
                      LatLng(_startLat!, _startLng!),
                      _zoomForRadius,
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('10 m',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: colorScheme.outline)),
                  Text('500 m',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: colorScheme.outline)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(_startLat!, _startLng!),
                    initialZoom: _zoomForRadius,
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
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: LatLng(_startLat!, _startLng!),
                          radius: _flightRadius,
                          useRadiusInMeter: true,
                          color: Colors.blue.withOpacity(0.12),
                          borderColor: Colors.blue,
                          borderStrokeWidth: 2.0,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(_startLat!, _startLng!),
                          width: 40,
                          height: 40,
                          child: Icon(Icons.location_on,
                              color: colorScheme.error, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDroneSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.droneInfoTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),

        if (_loadingDrones)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(),
          )
        else if (_knownDrones.isNotEmpty) ...[
          Text(
            l10n.recentlyUsed,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _knownDrones.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final drone = _knownDrones[i];
                final isActive =
                    _droneKennungController.text == drone.kennung &&
                    _droneModellController.text == drone.modell;
                return ActionChip(
                  avatar: Icon(
                    Icons.flight,
                    size: 14,
                    color: isActive
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(
                    drone.kennung,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive
                          ? Theme.of(context).colorScheme.onPrimary
                          : null,
                    ),
                  ),
                  backgroundColor: isActive
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  tooltip: drone.modell,
                  onPressed: () => setState(() => _selectDrone(drone)),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],

        Autocomplete<_DroneEntry>(
          optionsBuilder: (value) => _filteredDrones(value.text),
          displayStringForOption: (d) => d.kennung,
          fieldViewBuilder: (context, controller, focusNode, onSubmit) {
            if (controller.text != _droneKennungController.text) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.text = _droneKennungController.text;
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              });
            }
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: l10n.droneIdLabel,
                hintText: 'z.B. D-ABCD oder SN-12345',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.flight),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          controller.clear();
                          setState(() => _droneKennungController.clear());
                        },
                      )
                    : null,
              ),
              textCapitalization: TextCapitalization.characters,
              onChanged: (v) => _droneKennungController.text = v,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.droneIdRequired
                  : null,
            );
          },
          optionsViewBuilder: (context, onSelected, options) =>
              _droneDropdown(options, onSelected, showKennung: true),
        ),
        const SizedBox(height: 16),

        Autocomplete<_DroneEntry>(
          optionsBuilder: (value) => _filteredDrones(value.text),
          displayStringForOption: (d) => d.modell,
          fieldViewBuilder: (context, controller, focusNode, onSubmit) {
            if (controller.text != _droneModellController.text) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.text = _droneModellController.text;
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              });
            }
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: l10n.droneModelLabel,
                hintText: 'z.B. DJI Mini 4 Pro',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.precision_manufacturing),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          controller.clear();
                          setState(() => _droneModellController.clear());
                        },
                      )
                    : null,
              ),
              onChanged: (v) => _droneModellController.text = v,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.droneModelRequired
                  : null,
            );
          },
          optionsViewBuilder: (context, onSelected, options) =>
              _droneDropdown(options, onSelected, showKennung: false),
        ),
      ],
    );
  }

  Widget _droneDropdown(
    Iterable<_DroneEntry> options,
    void Function(_DroneEntry) onSelected, {
    required bool showKennung,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, i) {
              final drone = options.elementAt(i);
              return ListTile(
                dense: true,
                leading: Icon(
                  showKennung ? Icons.flight : Icons.precision_manufacturing,
                  size: 20,
                ),
                title: Text(
                  showKennung ? drone.kennung : drone.modell,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  showKennung ? drone.modell : drone.kennung,
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  onSelected(drone);
                  setState(() => _selectDrone(drone));
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherSelector(ColorScheme colorScheme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.weatherConditionsLabel, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _weatherOptions.map((option) {
            final label = _getWeatherLabel(context, option.key);
            final isSelected = _selectedWeather.contains(option.key);
            return FilterChip(
              selected: isSelected,
              showCheckmark: false,
              avatar: Icon(option.icon, size: 18,
                  color: isSelected ? Colors.white : option.color),
              label: Text(label),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              selectedColor: option.color,
              backgroundColor: option.color.withOpacity(0.1),
              side: BorderSide(
                  color: isSelected ? option.color : option.color.withOpacity(0.4)),
              onSelected: (selected) => setState(() {
                if (selected) {
                  _selectedWeather.add(option.key);
                } else {
                  _selectedWeather.remove(option.key);
                }
              }),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _windSpeedController,
          decoration: InputDecoration(
            labelText: l10n.windSpeedLabel,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.air),
            suffixText: l10n.windSpeedUnit,
            hintText: 'z.B. 15',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () =>
              setState(() => _showCustomWeather = !_showCustomWeather),
          icon: Icon(_showCustomWeather ? Icons.remove : Icons.add, size: 18),
          label: Text(_showCustomWeather
              ? l10n.removeCustomWeather
              : l10n.addCustomWeather),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        if (_showCustomWeather) ...[
          const SizedBox(height: 8),
          TextFormField(
            controller: _weatherCustomController,
            decoration: InputDecoration(
              labelText: l10n.customWeatherLabel,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.edit),
              hintText: l10n.customWeatherHint,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
        if (_selectedWeather.isNotEmpty ||
            _weatherCustomController.text.isNotEmpty ||
            _windSpeedController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
              ),
              child: Text('📋  ${_weatherPreview ?? ''}',
                  style: const TextStyle(fontSize: 13)),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.logFlightTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_startLat != null && _startLng != null)
                      _buildMapPreview(colorScheme, l10n),
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: _flightTitleController,
                      decoration: InputDecoration(
                        labelText: l10n.flightDesignation,
                        hintText: 'z.B. Inspektion Solaranlage Nord',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.label_outline),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.flightDesignationRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildDroneSection(l10n),
                    const SizedBox(height: 16),

                    Autocomplete<String>(
                      optionsBuilder: (value) => _filteredPilots(value.text),
                      fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                        if (controller.text != _pilotNameController.text) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.text = _pilotNameController.text;
                            controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: controller.text.length),
                            );
                          });
                        }
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: l10n.pilotNameLabel,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.person),
                            suffixIcon: controller.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      controller.clear();
                                      setState(() => _pilotNameController.clear());
                                    },
                                  )
                                : null,
                          ),
                          textCapitalization: TextCapitalization.words,
                          onChanged: (v) => _pilotNameController.text = v,
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(8),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, i) {
                                  final pilot = options.elementAt(i);
                                  return ListTile(
                                    dense: true,
                                    leading: const Icon(Icons.person, size: 20),
                                    title: Text(pilot),
                                    onTap: () {
                                      onSelected(pilot);
                                      setState(() => _pilotNameController.text = pilot);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    Text(l10n.flightDetailsTitle,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(l10n.startTimeLabel),
                      subtitle: Text(
                          DateFormat('dd.MM.yyyy HH:mm').format(_startTime)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectDateTime(context, true),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(l10n.endTimeOptionalLabel),
                      subtitle: Text(_endTime != null
                          ? DateFormat('dd.MM.yyyy HH:mm').format(_endTime!)
                          : l10n.notSet),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectDateTime(context, false),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _maxAltitudeController,
                      decoration: InputDecoration(
                        labelText: l10n.maxAltitudeLabelMeters,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.height),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildWeatherSelector(colorScheme, l10n),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: l10n.notesLabel,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _saveFlightLog,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16)),
                      child: Text(l10n.saveFlightLog,
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _flightTitleController.dispose();
    _droneKennungController.dispose();
    _droneModellController.dispose();
    _pilotNameController.dispose();
    _maxAltitudeController.dispose();
    _notesController.dispose();
    _weatherCustomController.dispose();
    _windSpeedController.dispose();
    super.dispose();
  }
}