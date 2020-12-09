import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ShowService extends StatefulWidget {
  @override
  _ShowServiceState createState() => _ShowServiceState();
}

class _ShowServiceState extends State<ShowService> {
  GoogleMapController controller;
  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor mapMarker;

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    print("images/${specify['eventType']}.png");
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify['lat'], specify['lng']),
      icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(),"images/${specify['eventType']}.png"),
      // icon: await BitmapDescriptor.fromAssetImage(
      //     ImageConfiguration(), "images/car-crash.png"),
      onTap: () {
        _onMarkerTapped(specify);
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance
        .collection('markers')
        .get()
        .then((markersDoc) {
      if (markersDoc.docs.isNotEmpty) {
        for (int i = 0; i < markersDoc.docs.length; i++) {
          initMarker(markersDoc.docs[i].data(), markersDoc.docs[i].id);
        }
      }
    });
  }

  void setCustomMarkers() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/marker.png');
  }

  setUpTimedFetch() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        getMarkerData();
        print('Get markers');
      });
    });
  }

  @override
  void initState() {
    // setCustomMarkers();
    getMarkerData();
    setUpTimedFetch();
    super.initState();
  }

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

  void _onMarkerTapped(marker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
            height: 500,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: Image.network(
                      marker['imageUrl'],
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: SizedBox.expand(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedButton.icon(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              label: Text(
                                'สร้างโดย : ${marker['createdName']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                              icon: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                              ),
                              textColor: Colors.white,
                              splashColor: Colors.red,
                              color: Colors.lightGreen,
                            ),
                            Text(
                              'บริเวณ : ${marker['namePoint']}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Kanit',
                              ),
                              // textAlign: TextAlign.left,
                            ),
                            Text(
                              'เวลา : ${new DateFormat("dd-MM-yyyy hh:mm").format(marker['createdOn'].toDate())}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Kanit',
                              ),
                              // textAlign: TextAlign.center,
                            ),
                            FloatingActionButton.extended(
                              onPressed: () => {Navigator.of(context).pop()},
                              label: Text('ปิด'),
                              icon: Icon(Icons.clear),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
          myLocationEnabled: true,
          markers: Set<Marker>.of(markers.values),
          mapType: MapType.terrain,
          initialCameraPosition: CameraPosition(
            target: LatLng(18.7768121, 98.9860395),
            zoom: 12.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToMe,
        label: Text('ตำแหน่งของคุณ'),
        icon: Icon(Icons.near_me),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
