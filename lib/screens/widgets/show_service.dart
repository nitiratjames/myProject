import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class ShowService extends StatefulWidget {
  @override
  _ShowServiceState createState() => _ShowServiceState();
}

class _ShowServiceState extends State<ShowService> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(18.7850863, 98.9365153),
  //   zoom: 14.4746,
  // );

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(18.7850863, 98.9365153),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  Future _goToMe() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 16,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(
          target: LatLng(18.7768121, 98.9860395),
          zoom: 12.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToMe,
        label: Text('ตำแหน่งของคุณ'),
        icon: Icon(Icons.near_me),
      ),
    );
  }

// Future<void> _goToTheLake() async {
//   final GoogleMapController controller = await _controller.future;
//   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
// }
}
