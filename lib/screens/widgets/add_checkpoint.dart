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

class _AddCheckPointState extends State<AddCheckPoint> {
  File _image;
  String imageUrl;
  double lat, lng;
  String namePoint;

  @override
  void initState() {
    super.initState();
    _goToMe();
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
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
        onTap: () {
          print('Tapped');
        },
        onDragEnd: ((newPosition) {
          lat = newPosition.latitude;
          lng = newPosition.longitude;
        }),
        draggable: true,
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
            padding: const EdgeInsets.all(5.0),
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

    if (permissionStatus.isGranted){
      var file = File(_image.path);
      if (_image != null){
        //Upload to Firebase
        var snapshot = await _storage.ref()
            .child('images/checkpoint_${lat}_${lng}')
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

  Future<void> addCheckpoint() async{
    CollectionReference checkpoints = FirebaseFirestore.instance.collection('checkpoints');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid.toString();
    checkpoints.doc().set({
      'namePoint':namePoint,
      'imageUrl':imageUrl,
      'lat':lat,
      'lng':lng,
      'createdOn':FieldValue.serverTimestamp(),
      'createdBy':uid,
      'createdName':auth.currentUser.displayName,
      'isActive':true,
    });

    MaterialPageRoute materialPageRoute =
    MaterialPageRoute(builder: (BuildContext context) => Service());
    Navigator.of(context).pushAndRemoveUntil(
        materialPageRoute, (Route<dynamic> route) => false);
  }

  showLoadingDialog(BuildContext context){
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("กำลังดำเนินการ" )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
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
                if (snapshot.hasData == true) {
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
        onPressed: () {
          if (namePoint == null ) {
            print('if namePoint : $namePoint _image:$_image lat:$lat lng:$lng');
            _showDialog('กรุณากรอกข้อมูลให้ครบถ้วน');
          }else if(_image == null){
            print('if namePoint : $namePoint _image:$_image lat:$lat lng:$lng');
            _showDialog('กรุณาเลือกรูปภาพ');
          }else if((lat == null || lng == null)){
            print('if namePoint : $namePoint _image:$_image lat:$lat lng:$lng');
            _showDialog('กรุณาปักหมุด');
          }
          else {
            try{
              showLoadingDialog(context);
              uploadImage();
            }catch(e){

            }
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
