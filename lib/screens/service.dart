import 'package:checkpoint/screens/widgets/show_service.dart';
import 'package:checkpoint/screens/widgets/add_checkpoint.dart';
import 'package:checkpoint/screens/widgets/user_manage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkpoint/screens/home.dart';

class Service extends StatefulWidget {
  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  String login = null, userRole = null;
  String currentPage = 'หน้าหลัก';
  Widget currentWidget = ShowService();

  @override
  void initState() {
    findUser();
    super.initState();
  }

  Future<bool> checkUser()async{
    if(login != null && userRole != null){
      return true;
    }else{
      return false;
    }
  }

  Future<void> findUser() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = await firebaseAuth.currentUser;
    final DocumentReference document =
        Firestore.instance.collection("users").doc(user.uid);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        login = user.displayName;
        userRole = snapshot.data()['role'];
        print(login);
        print(userRole);
      });
    });
  }

  Future<void> processingSignOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((res) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  Widget showLogo() {
    return Container(
      width: 52.0,
      height: 52.0,
      child: Container(child: Image.asset('images/logo.gif')),
    );
  }

  Widget showLogin() {
    return  FutureBuilder(
      future: checkUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print(snapshot.hasData);
        if (snapshot.hasData == true) {
          return  Column(
            children: [
              Text(
                'Login by ${login}',
                style: TextStyle(
                  fontFamily: 'Kanit',
                ),
              ),
              Text(
                'Role : ${userRole}',
                style: TextStyle(
                  fontFamily: 'Kanit',
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
    );
  }

  Widget showText() {
    return Text(
      'มีด่านบอกด้วย',
      style: TextStyle(
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Kanit',
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

  Widget showService() {
    return ListTile(
      leading: Icon(
        Icons.list,
        size: 35.0,
      ),
      title: Text(
        'หน้าหลัก',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Kanit',
        ),
      ),
      subtitle: Text(
        'ดูข้อมูล Google Maps',
        style: TextStyle(
          fontFamily: 'Kanit',
        ),
      ),
      onTap: () {
        setState(() {
          currentPage = 'หน้าหลัก';
          currentWidget = ShowService();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget showAddCheckpoint() {
    return ListTile(
      leading: Icon(
        Icons.room,
        size: 35.0,
      ),
      title: Text(
        'แจ้งด่านตรวจ',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Kanit',
        ),
      ),
      subtitle: Text(
        'เพิ่มข้อมูลเบื่องต้น',
        style: TextStyle(
          fontFamily: 'Kanit',
        ),
      ),
      onTap: () {
        setState(() {
          currentPage = 'แจ้งด่านตรวจ';
          currentWidget = AddCheckPoint();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget userManage() {
    return ListTile(
      leading: Icon(
        Icons.account_circle,
        size: 35.0,
      ),
      title: Text(
        'จัดการผู้ใช้',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Kanit',
        ),
      ),
      subtitle: Text(
        'เพิ่มข้อมูลเบื่องต้น',
        style: TextStyle(
          fontFamily: 'Kanit',
        ),
      ),
      onTap: () {
        setState(() {
          currentPage = 'จัดการผู้ใช้';
          currentWidget = UserManage();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget showHead() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(-0.5, -0.7),
          radius: 2.0,
          colors: <Color>[
            Colors.white,
            Colors.pink.shade200,
          ],
        ),
      ),
      child: Column(
        children: [
          showAppName(),
          showLogin(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: [
          showHead(),
          showService(),
          showAddCheckpoint(),
          userRole != 'ADMIN' ? Container(): userManage()
          // userManage(),
        ],
      ),
    );
  }

  Widget signOutButton() {
    return IconButton(
      icon: Icon(
        Icons.exit_to_app_rounded,
        color: Colors.white,
        size: 30.0,
      ),
      tooltip: "ออกจากระบบ",
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
        title: Text(
          '$currentPage',
          style: TextStyle(color: Colors.white, fontFamily: 'Kanit'),
        ),
        backgroundColor: Colors.pink.shade200,
        actions: <Widget>[
          signOutButton(),
        ],
      ),
      body: currentWidget,
      drawer: showDrawer(),
      // Container(
      //   decoration: BoxDecoration(
      //     gradient: RadialGradient(
      //       center: const Alignment(-0.5, -0.7),
      //       radius: 3.0,
      //       colors: <Color>[
      //         Colors.white,
      //         Colors.pink.shade200,
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
