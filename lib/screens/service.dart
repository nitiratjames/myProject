import 'package:checkpoint/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Service extends StatefulWidget {
  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  Future<void> processingSignOut()async{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((res){
        MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context) => Home());
        Navigator.of(context).pushAndRemoveUntil(materialPageRoute, (Route<dynamic> route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'หน้าหลัก',
          style: TextStyle(color: Colors.white, fontFamily: 'Kanit'),
        ),
        backgroundColor: Colors.pink.shade200,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              processingSignOut();
              // _showDialog();
            },
          ),
        ],
      ),body: Text('lll'),
    );
  }
}
