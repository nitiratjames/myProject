import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //  _formKey and _autoValidate
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  String name;
  String email;
  String password;

  void validateInputs() {
    if (formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      formKey.currentState.save();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        autoValidate = true;
      });
    }
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
          IconButton(
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              // onPressed: validateInputs,
              // do something
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.5, -0.7),
              radius: 1.0,
              colors: <Color>[
                Colors.white,
                Colors.pink.shade200,
              ],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: new Container(
                    margin: new EdgeInsets.all(15.0),
                    child: new Form(
                      key: formKey,
                      autovalidate: autoValidate,
                      child: FormUI(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Here is our Form UI
Widget FormUI() {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: new Column(
      children: <Widget>[
        new TextFormField(
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
          ),
          keyboardType: TextInputType.text,
          validator: (String arg) {
            if (arg.length < 3)
              return 'Name must be more than 2 charater';
            else
              return null;
          },
          onSaved: (String val) {
            // name = val;
          },
        ),
        new SizedBox(
          height: 30.0,
        ),
        new TextFormField(
          decoration: const InputDecoration(
            labelText: 'อีเมล',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(
              fontFamily: 'Kanit',
              color: Colors.black,
              fontSize: 20.0,
            ),
            prefixIcon: Icon(
              Icons.email,
              size: 40.0,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          onSaved: (String val) {
            // email = val;
          },
        ),
        new SizedBox(
          height: 30.0,
        ),
        new TextFormField(
          decoration: const InputDecoration(
            labelText: 'รหัสผ่าน',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 20.0,
              color: Colors.black,
            ),
            prefixIcon: Icon(
              Icons.vpn_key,
              size: 40.0,
            ),
          ),
          keyboardType: TextInputType.text,
          validator: validatePassword,
          onSaved: (String val) {
            // password = val;
          },
        ),
        new SizedBox(
          height: 10.0,
        ),
      ],
    ),
  );
}

String validateName(String value) {
  print(value);
  if (value.length < 3)
    return 'Name must be more than 3 charater';
  else
    return null;
}

String validatePassword(String value) {
// Indian Mobile number are of 10 digit only
  if (value.length < 6)
    return 'Password must be more than 6 charater';
  else
    return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}
