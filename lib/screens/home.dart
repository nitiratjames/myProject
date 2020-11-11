import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget showAppName() {
    return Text(
      'ฮาว่าละ !!!',
      style: TextStyle(
        fontSize: 40.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Kanit',
      ),
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
    return RaisedButton(
      color: Colors.blue,
      child: Text(
        'Sign In',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget singUpButton() {
    return RaisedButton(
      color: Colors.pink.shade300,
      child: Text(
        'Sign Up',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        print('gggggggggg');
      },
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
              colors: [
                Colors.white,
                Colors.pink.shade200,
              ],
              radius: 1.1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showAppName(),
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
