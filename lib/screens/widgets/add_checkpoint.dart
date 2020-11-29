import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddCheckPoint extends StatefulWidget {
  @override
  _AddCheckPointState createState() => _AddCheckPointState();
}

class _AddCheckPointState extends State<AddCheckPoint> {
  File _image;
  double lat, lng;

  @override
  void initState() {
    super.initState();
    _goToMe();
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    }catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  Future<bool> _goToMe() async {
    LocationData locationData = await findLocationData();
    lat = locationData.latitude;
    lng = locationData.longitude;
    return true;
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myMap'),
        position: LatLng(lat, lng),
      )
    ].toSet();
  }

  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 14.0,
    );
    return Container(
      height: 400,
      child: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.terrain,
        initialCameraPosition: cameraPosition,
        onMapCreated: (controller) {},
        markers: myMarker(),
      ),
    );
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('แกลเลอรี'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('กล้อง'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 400.0,
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ชื่อบริเวณ',
                  labelStyle: TextStyle(
                    fontFamily: 'Kanit',
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                  prefixIcon: Icon(
                    Icons.assistant_photo_outlined,
                    size: 40.0,
                  ),
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                  )),
              maxLines: 2,
              keyboardType: TextInputType.text,
            ),
          )
        ],
      );

  Widget groupImage() {
    return Container(
      child: GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: _image != null
            ? ClipRRect(
                child: Image.file(
                  _image,
                  width: 400,
                  height: 300,
                  fit: BoxFit.fitWidth,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50)),
                width: 100,
                height: 100,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey[800],
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            new SizedBox(
              height: 20.0,
            ),
            groupImage(),
            new SizedBox(
              height: 20.0,
            ),
            nameForm(),
            new SizedBox(
              height: 30.0,
            ),
            FutureBuilder(
              future: _goToMe(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print(snapshot.hasData);
                if (snapshot.hasData) {
                  return showMap();
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            new SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToMe,
        label: Text(
          'แจ้งเลย',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: 'Kanit',
          ),
        ),
        icon: Icon(Icons.cloud_upload),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
