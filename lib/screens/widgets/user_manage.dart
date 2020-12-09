import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkpoint/screens/widgets/user/userItem.dart';

class UserManage extends StatefulWidget {
  @override
  _UserManageState createState() => _UserManageState();
}

String filter;

class _UserManageState extends State<UserManage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    filter = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "username",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (filter != "" && filter != null)
                    ? FirebaseFirestore.instance
                        .collection("users")
                        .where("role", isEqualTo: "USER")
                        .where('username', isEqualTo: filter)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("users")
                        .where("role", isEqualTo: "USER")
                        .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot users = snapshot.data.docs[index];
                            return UserItem(
                              documentSnapshot: users,
                              id: users.id,
                              username: users['username'],
                              email: users['email'],
                              createdOn: users['createdOn'],
                              role: users['role'],
                              isActive: users['isActive'],
                              createMarker: users['createMarker'],
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
