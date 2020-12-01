import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkpoint/screens/widgets/user/userItem.dart';

class UserManage extends StatefulWidget {
  @override
  _UserManageState createState() => _UserManageState();
}

class _UserManageState extends State<UserManage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream:
            // (selectedUser != "" && selectedUser != null)
            //     ? FirebaseFirestore.instance
            //     .collection("users")
            //     .where("role", isEqualTo: "USER")
            //     .where("isActive", isEqualTo:selectedUser)
            //     .snapshots()
            //     :
            FirebaseFirestore.instance
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
                    );
                  },
                );
        },
      ),
    );
  }
}
