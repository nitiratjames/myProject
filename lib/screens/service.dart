import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:checkpoint/screens/home.dart';

class Service extends StatefulWidget {
  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {

  Future<void> processingSignOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((res) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  Widget signOutButton() {
    return IconButton(
      icon: Icon(
        Icons.exit_to_app_rounded,
        color: Colors.white,
        size: 30.0,
      ),
      onPressed: () {
        _showDialog();
      },
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
              size: 35.0,
            ),
            title: Text(
              'คุณแน่ใจหรือไม่',
              style: TextStyle(color: Colors.red, fontSize: 24.0),
            ),
          ),
          content: Text('คุณต้องการจะลงชื่อออกจากระบบ ?'),
          actions: <Widget>[
            cancelButton(),
            okButton(),
          ],
        );
      },
    );
  }

  Widget cancelButton() {
    return new FlatButton(
      child: new Text(
        "ยกเลิก",
        style: TextStyle(fontSize: 18.0),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget okButton() {
    return new FlatButton(
      child: new Text(
        "ตกลง",
        style: TextStyle(fontSize: 18.0),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        processingSignOut();
      },
    );
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
          signOutButton(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.5, -0.7),
            radius: 3.0,
            colors: <Color>[
              Colors.white,
              Colors.pink.shade200,
            ],
          ),
        ),
      ),
    );
  }
}
