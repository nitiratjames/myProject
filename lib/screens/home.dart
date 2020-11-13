import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:checkpoint/screens/service.dart';
import 'package:checkpoint/screens/register.dart';
import 'package:checkpoint/screens/authen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    if (user != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Service());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }
  }

  Widget showAppTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(width: 0.0, height: 100.0),
        TypewriterAnimatedTextKit(
            onTap: () {
              print("Tap Event");
            },
            text: [
              "Discipline is the best tool",
              "Design first, then code",
              "Do not patch bugs out, rewrite them",
              "Do not test bugs out, design them out",
            ],
            textStyle: TextStyle(
              fontSize: 20.0,
              fontFamily: "Architects",
              color: Colors.black,
            ),
            textAlign: TextAlign.start,
            alignment: AlignmentDirectional.topStart // or Alignment.topLeft
            ),
      ],
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
      'มีด่านบอกด้วย !',
      style: TextStyle(
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Kanit',
      ),
    );
  }

  Widget showLogoBig() {
    return Container(
      width: 280.0,
      height: 140.0,
      child: Container(child: Image.asset('images/police_logo.gif')),
    );
  }

  Widget singInButton() {
    return ButtonTheme(
      minWidth: 150.0,
      height: 50.0,
      child: RaisedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Authen()),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        label: Text(
          'ลงชื่อเข้าใช้',
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
            fontFamily: 'Kanit',
          ),
        ),
        icon: Icon(
          Icons.keyboard,
          color: Colors.white,
        ),
        textColor: Colors.white,
        splashColor: Colors.red,
        color: Colors.blue,
      ),
    );
  }

  Widget singUpButton() {
    return ButtonTheme(
      minWidth: 150.0,
      height: 50.0,
      child: RaisedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Register()),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        label: Text(
          'ลงทะเบียน',
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
            fontFamily: 'Kanit',
          ),
        ),
        icon: Icon(
          Icons.note_add,
          color: Colors.white,
        ),
        textColor: Colors.white,
        splashColor: Colors.red,
        color: Colors.green,
      ),
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        singInButton(),
        SizedBox(
          width: 20.0,
        ),
        singUpButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.5, -0.7),
              radius: 0.8,
              colors: <Color>[
                Colors.white,
                Colors.pink.shade200,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showAppName(),
                SizedBox(
                  height: 100.0,
                ),
                showAppTitle(),
                SizedBox(
                  height: 50.0,
                ),
                showLogoBig(),
                SizedBox(
                  height: 30.0,
                ),
                showButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
