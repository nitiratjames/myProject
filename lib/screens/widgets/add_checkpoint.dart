import 'dart:async';
import 'dart:io';
import 'package:checkpoint/screens/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddCheckPoint extends StatefulWidget {
  @override
  _AddCheckPointState createState() => _AddCheckPointState();
}

class Item {
  const Item(this.name,this.type, this.icon);

  final String name;
  final String type;
  final Icon icon;
}

class _AddCheckPointState extends State<AddCheckPoint> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  Completer<GoogleMapController> _mapController = Completer();
  LocationData currentLocation;
  File _image;
  String imageUrl;
  double lat, lng;
  String namePoint;
  Item selectedItemEvent;
  String selectedEvent;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 15);
    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 15);
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
            width: 300.0,
            child: TextField(
              onChanged: (value) => namePoint = value.trim(),
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
              maxLines: 4,
              keyboardType: TextInputType.text,
            ),
          )
        ],
      );

  List<Item> events = <Item>[
    const Item(
        'ด่านตรวจ',
        'checkpoint',
        Icon(
          Icons.local_police,
          color: Colors.red,
        )),
    const Item(
        'อุบัติเหตุ',
        'accident',
        Icon(
          Icons.local_hospital,
          color: Colors.red,
        )),
    const Item(
        'รถติด',
        'traffic_jam',
        Icon(
          Icons.directions_car,
          color: Colors.red,
        )),
    const Item(
        'อื่นๆ',
        'other',
        Icon(
          Icons.list_alt,
          color: Colors.red,
        )),
  ];

  Widget eventType() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<Item>(
            iconSize: 50.0,
            style: TextStyle(
              fontFamily: 'Kanit',
              color: Colors.black,
              fontSize: 20.0,
            ),
            hint: Text(
              "เลือกประเภทเหตุการณ์",
            ),
            value: selectedItemEvent,
            onChanged: (Item Value) {
              setState(() {
                selectedEvent = Value.type;
                selectedItemEvent = Value;
              });
            },
            items: events.map((Item event) {
              return DropdownMenuItem<Item>(
                value: event,
                child: Row(
                  children: <Widget>[
                    event.icon,
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      event.name,
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
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

  void _showDialog(String title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: ListTile(
            leading: Icon(
              Icons.assignment,
              color: Colors.red,
              size: 35.0,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "ตกลง",
                style: TextStyle(fontSize: 18.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      var file = File(_image.path);
      if (_image != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            .child('images/markers_${lat}_${lng}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
        addCheckpoint();
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  Future<void> addCheckpoint() async {
    CollectionReference markers =
        FirebaseFirestore.instance.collection('markers');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid.toString();
    markers.doc().set({
      'eventType': selectedEvent,
      'namePoint': namePoint,
      'imageUrl': imageUrl,
      'lat': lat,
      'lng': lng,
      'createdOn': FieldValue.serverTimestamp(),
      'createdBy': uid,
      'createdName': auth.currentUser.displayName,
      'isActive': true,
    });

    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) => Service());
    Navigator.of(context)
        .pushAndRemoveUntil(materialPageRoute, (Route<dynamic> route) => false);
  }

  showLoadingDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 5), child: Text("กำลังดำเนินการ")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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

  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    currentLocation = await getCurrentLocation();
    if (currentLocation != null) {
      lat = currentLocation.latitude;
      lng = currentLocation.longitude;
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
      );
      setState(() {
        _markers[markerId] = marker;
      });

      // Future.delayed(Duration(seconds: 1), () async {
      GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 16.0,
          ),
        ),
      );
      // });
    }
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getCurrentLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.hasData);
          if (snapshot.hasData == true) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white70,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 20.0,
                          ),
                          groupImage(),
                          new SizedBox(
                            height: 10.0,
                          ),
                          eventType(),
                          new SizedBox(
                            height: 10.0,
                          ),
                          nameForm(),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child:
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      heightFactor: 0.3,
                      widthFactor: 2.5,
                      child:  Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: GoogleMap(
                          markers: Set<Marker>.of(_markers.values),
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(18.7768121, 98.9860395),
                            zoom: 10.0,
                          ),
                          myLocationEnabled: true,
                          onCameraMove: (CameraPosition position) {
                            if (_markers.length > 0) {
                              MarkerId markerId = MarkerId(_markerIdVal());
                              Marker marker = _markers[markerId];
                              Marker updatedMarker = marker.copyWith(
                                positionParam: position.target,
                              );
                              setState(() {
                                _markers[markerId] = updatedMarker;
                                lat = position.target.latitude;
                                lng = position.target.longitude;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_image == null) {
            print(
                'if namePoint : $namePoint _image:$_image lat:$lat lng:$lng selected event:$selectedEvent');
            _showDialog('กรุณาเลือกรูปภาพ');
          } else if (selectedEvent == null) {
            print(
                'if namePoint : $namePoint _image:$_image lat:$lat lng:$lng selected event:$selectedEvent');
            _showDialog('กรุณาเลือกประเภทเหตุการณ์');
          } else if (namePoint == null) {
            print(
                'if namePoint : $namePoint _image:$_image lat:$lat lng:$lng selected event:$selectedEvent');
            _showDialog('กรุณากรอกชื่อบริเวณ');
          } else if ((lat == null || lng == null)) {
            print(
                'if namePoint : $namePoint _image:$_image lat:$lat lng:$lng selected event:$selectedEvent');
            _showDialog('กรุณาปักหมุด');
          } else {
            try {
              showLoadingDialog(context);
              uploadImage();
            } catch (e) {}
          }
        },
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
