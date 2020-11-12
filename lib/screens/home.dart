import 'package:checkpoint/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget showAppName() {
    return Text(
      'ฮาว่าละ !!!',
      style: TextStyle(
        fontSize: 70.0,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        fontFamily: 'Kanit',
      ),
    );
  }

  Widget showAppTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(width: 0.0, height: 100.0),
        Text(
          "SAFE ",
          style: TextStyle(
            fontSize: 40.0,
            fontFamily: 'Architects',
            // fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 0.0, height: 100.0),
        RotateAnimatedTextKit(
            duration: Duration(
              milliseconds: 2000,
            ),
            onTap: () {
              print("Tap Event");
            },
            text: [
              "FIRST",
              "LIFE",
              "FREEDOM",
            ],
            textStyle: TextStyle(
              fontSize: 40.0,
              fontFamily: "Architects",
              // decoration: TextDecoration.underline,
            ),
            textAlign: TextAlign.start),
      ],
    );
  }

  Widget showLogo() {
    return Container(
      width: 200.0,
      height: 220.0,
      child: Container(child: Image.asset('images/logo.gif')),
    );
  }

  Widget singInButton() {
    return ButtonTheme(
      minWidth: 150.0,
      height: 50.0,
      child: RaisedButton.icon(
        onPressed: () {
          print('Button Clicked.');
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
                showLogo(),
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
