// lib/screens/address/map_picker_osm_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerOSMScreen extends StatefulWidget {
  const MapPickerOSMScreen({super.key});

  @override
  State<MapPickerOSMScreen> createState() => _MapPickerOSMScreenState();
}

class _MapPickerOSMScreenState extends State<MapPickerOSMScreen> {
  LatLng pickedLocation = LatLng(-6.2, 106.816666); // default: Jakarta

  void _handleTap(LatLng latlng) {
    setState(() {
      pickedLocation = latlng;
    });
  }

  void _submit() {
    Navigator.pop(context, {
      'lat': pickedLocation.latitude,
      'long': pickedLocation.longitude,
      'address': "Lat: ${pickedLocation.latitude}, Lng: ${pickedLocation.longitude}",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Lokasi (OSM)")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: pickedLocation,
          initialZoom: 13.0,
          onTap: (tapPosition, latlng) => _handleTap(latlng),
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: pickedLocation,
                width: 60,
                height: 60,
                child: const Icon(Icons.location_on, size: 40, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: _submit,
          child: const Text("Gunakan Lokasi Ini"),
        ),
      ),
    );
  }
}
