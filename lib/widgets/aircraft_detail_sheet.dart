import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/aircraft.dart';

class AircraftDetailSheet extends StatelessWidget {
  final Aircraft aircraft;

  const AircraftDetailSheet({super.key, required this.aircraft});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final altStr = aircraft.baroAltitude != null
        ? '${aircraft.baroAltitude!.toStringAsFixed(0)} m'
        : 'n/a';
    final velStr = aircraft.velocity != null
        ? '${(aircraft.velocity! * 3.6).toStringAsFixed(0)} km/h'
        : 'n/a';
    final trackStr = aircraft.trueTrack != null
        ? '${aircraft.trueTrack!.toStringAsFixed(0)}°'
        : 'n/a';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(
                aircraft.isUAV
                    ? Icons.connecting_airports
                    : aircraft.isHelicopter
                        ? Icons.air
                        : Icons.airplanemode_active,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aircraft.callsign?.isNotEmpty == true
                          ? aircraft.callsign!
                          : aircraft.icao24.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (aircraft.callsign?.isNotEmpty == true)
                      Text(aircraft.icao24.toUpperCase(),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              if (aircraft.onGround)
                Chip(
                  label: Text(l10n.aircraft_onground),
                  backgroundColor: Colors.grey,
                  labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                ),
            ],
          ),
          const Divider(height: 24),


          _DetailRow(
              icon: Icons.flag,
              label: l10n.aircraft_origin,
              value: aircraft.originCountry ?? 'n/a'),
          _DetailRow(icon: Icons.height, label: l10n.aircraft_altitude, value: altStr),
          _DetailRow(
              icon: Icons.speed, label: l10n.aircraft_speed, value: velStr),
          _DetailRow(
              icon: Icons.navigation, label: l10n.aircraft_heading, value: trackStr),
          _DetailRow(
              icon: Icons.category,
              label: l10n.aircraft_type,
              value: _categoryLabel(aircraft.category, l10n)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }


  String _categoryLabel(int cat, AppLocalizations l10n) {
    switch (cat) {
      case 0:
        return l10n.aircraftCat0;
      case 1:
        return l10n.aircraftCat1;
      case 2:
        return l10n.aircraftCat2;
      case 3:
        return l10n.aircraftCat3;
      case 4:
        return l10n.aircraftCat4;
      case 5:
        return l10n.aircraftCat5;
      case 6:
        return l10n.aircraftCat6;
      case 7:
        return l10n.aircraftCat7;
      case 8:
        return l10n.aircraftCat8;
      case 9:
        return l10n.aircraftCat9;
      case 10:
        return l10n.aircraftCat10;
      case 11:
        return l10n.aircraftCat11;
      case 12:
        return l10n.aircraftCat12;
      case 13:
        return l10n.aircraftCat13;
      case 14:
        return l10n.aircraftCat14;
      case 15:
        return l10n.aircraftCat15;
      case 16:
        return l10n.aircraftCat16;
      case 17:
        return l10n.aircraftCat17;
      case 18:
        return l10n.aircraftCat18;
      case 19:
        return l10n.aircraftCat19;
      case 20:
        return l10n.aircraftCat20;
      default:
        return l10n.aircraftCatOther;
    }
  }
}


class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Flexible(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}