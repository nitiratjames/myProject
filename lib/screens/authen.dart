import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:checkpoint/screens/service.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  // Method
  Widget backButton() {
    return IconButton(
      icon: Icon(Icons.navigate_before),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget content() {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            showAppName(),
            new SizedBox(
              height: 30.0,
            ),
            emailText(),
            new SizedBox(
              height: 30.0,
            ),
            passwordText(),
          ],
        ),
      ),
    );
  }

  Widget showAppName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        showLogo(),
        showText(),
      ],
    );
  }

  Widget showLogo() {
    return Container(
      width: 52.0,
      height: 52.0,
      child: Container(child: Image.asset('images/logo.gif')),
    );
  }

  Widget showText() {
    return Text(
      'CHECK POINT',
      style: TextStyle(
        fontSize: 38.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Kanit',
      ),
    );
  }

  Widget showSignInName() {
    return SizedBox(
      width: 400.0,
      child: TextLiquidFill(
        text: 'เข้าสู่ระบบ',
        waveColor: Colors.black87,
        boxBackgroundColor: Colors.pink.shade200,
        textStyle: TextStyle(
          fontSize: 70.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kanit',
        ),
        boxHeight: 150.0,
      ),
    );
  }

  Widget emailText() {
    return Container(
      width: 350.0,
      child: TextFormField(
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
      ),
    );
  }

  Widget passwordText() {
    return Container(
      width: 350.0,
      child: TextFormField(
        obscureText: true,
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
      ),
    );
  }

  void alertMessage(String title, String message) {
    print(message);
    if (title != null) {
      if (title == 'user-not-found') {
        title = 'ไม่พบอีเมลผู้ใช้';
      }
      if (title == 'wrong-password') {
        title = 'รหัสผ่านผิด';
      }
      if (title == 'unknown') {
        title = 'ไม่ทราบ';
      }
    }
    if (message != null) {
      if (message ==
          'There is no user record corresponding to this identifier. The user may have been deleted.') {
        message = 'ไม่มีบันทึกผู้ใช้ที่ตรงกับตัวระบุนี้ ผู้ใช้อาจถูกลบ';
      }
      if (message ==
          'The password is invalid or the user does not have a password.') {
        message = 'รหัสผ่านไม่ถูกต้องหรือผู้ใช้ไม่มีรหัสผ่าน';
      }
      if (message ==
          'Given String is empty or null') {
        message = 'กรุณากรอกข้อมูลลงในช่องว่าง';
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

  Future<void> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((res) {
      print('auth');
      MaterialPageRoute materialPageRoute =
      MaterialPageRoute(builder: (BuildContext context) => Service());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }).catchError((res){
      print(res);
      String title = res.code;
      String message = res.message;
      alertMessage(title, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
          child: Stack(
            children: <Widget>[
              backButton(),
              content(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _formKey.currentState.save();
          print('email = $_email , password = $_password');
          checkAuthen();
        },
        label: Text(
          'ตกลง',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: 'Kanit',
          ),
        ),
        icon: Icon(Icons.assignment_turned_in_outlined),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
