import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:checkpoint/screens/service.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // variable
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password;

  // method
  Widget registerButton() {
    return IconButton(
      icon: Icon(
        Icons.cloud_upload,
        color: Colors.white,
        size: 30.0,
      ),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          print('name = $_name email = $_email password = $_password');
          registerThread();
        }
      },
    );
  }

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(email: _email, password: _password)
        .then((res) {
      setupProfile();
    }).catchError((res) {
      String title = res.code;
      String message = res.message;
      alertMessage(title, message);
    });
  }

  Future<void> setupProfile() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    var name, email, uid, emailVerified;
    if (user != null) {
      name = user.displayName;
      email = user.email;
      emailVerified = user.emailVerified;
      uid = user.uid; // The user's ID, unique to the Firebase project. Do NOT use
      // this value to authenticate with your backend server, if
      // you have one. Use User.getToken() instead.
      // print(user);
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Service());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }
  }

  void alertMessage(String title, String message) {
    print(message);
    if (title != null) {
      if (title == 'email-already-in-use') {
        title = 'อีเมลถูกใช้งานแล้ว';
      }
    }
    if (message != null) {
      if (message ==
          'The email address is already in use by another account.') {
        message = 'ที่อยู่อีเมลนี้ถูกใช้โดยบัญชีอื่นแล้ว';
      }
    }
    _showDialog(title, message);
  }

// user defined function
  void _showDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: ListTile(
            leading: Icon(
              Icons.lock,
              color: Colors.red,
              size: 35.0,
            ),
            title: Text(
              title,
              style: TextStyle(color: Colors.red, fontSize: 24.0),
            ),
          ),
          content: new Text(
            message,
            style: TextStyle(fontSize: 18.0),
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

  Widget nameText() {
    return TextFormField(
      decoration: const InputDecoration(
          prefix: Text('คุณ :'),
          border: OutlineInputBorder(),
          labelText: 'ชื่อ',
          labelStyle: TextStyle(
            fontFamily: 'Kanit',
            color: Colors.black,
            fontSize: 20.0,
          ),
          prefixIcon: Icon(
            Icons.person,
            size: 40.0,
          ),
          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: 16.0,
          )),
      keyboardType: TextInputType.text,
      validator: (String val) {
        if (val.length < 3)
          return 'ชื่อต้องมีความยาวมากกว่า 3 อักขระ';
        else
          return null;
      },
      onSaved: (String val) {
        _name = val.trim();
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'อีเมล',
        border: OutlineInputBorder(),
        labelStyle: TextStyle(
          fontFamily: 'Kanit',
          color: Colors.black,
          fontSize: 20.0,
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 16.0,
        ),
        prefixIcon: Icon(
          Icons.email,
          size: 40.0,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String val) {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(val))
          return 'ป้อนอีเมลรูปแบบที่ถูกต้อง';
        else
          return null;
      },
      onSaved: (String val) {
        _email = val.trim();
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'รหัสผ่าน',
        border: OutlineInputBorder(),
        labelStyle: TextStyle(
          fontFamily: 'Kanit',
          fontSize: 20.0,
          color: Colors.black,
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 16.0,
        ),
        prefixIcon: Icon(
          Icons.vpn_key,
          size: 40.0,
        ),
      ),
      keyboardType: TextInputType.text,
      validator: (String val) {
        if (val.isEmpty) {
          return 'กรุณากรอกรหัสผ่าน';
        } else {
          if (val.length < 6)
            return 'รหัสผ่านต้องมีความยาวมากกว่า 6 อักขระ';
          else
            return null;
        }
      },
      onSaved: (String val) {
        _password = val.trim();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'ลงทะเบียน',
          style: TextStyle(color: Colors.white, fontFamily: 'Kanit'),
        ),
        backgroundColor: Colors.pink.shade200,
        actions: <Widget>[
          registerButton(),
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
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              nameText(),
              new SizedBox(
                height: 30.0,
              ),
              emailText(),
              new SizedBox(
                height: 30.0,
              ),
              passwordText(),
              // imageUpload(),
            ],
          ),
        ),
      ),
    );
  }
}
