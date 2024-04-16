import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  final String? longitude;
  final String? latitude;
  const GoogleMapsScreen(
      {Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  static Set<Marker> markers = {};

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    markers.clear();
    markers.add(Marker(
      markerId: const MarkerId('currentLocation'),
      position: LatLng(double.tryParse(widget.latitude!)!,
          double.tryParse(widget.longitude!)!),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Safety Helmet",
          style: GoogleFonts.fjallaOne(color: Colors.white),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(double.tryParse(widget.latitude!)!,
                double.tryParse(widget.longitude!)!),
            zoom: 15.0),
        mapType: MapType.normal,
        markers: markers,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
