
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkpoint/screens/widgets/marker/markerItem.dart';

class MarkerManage extends StatefulWidget {
  @override
  _MarkerManageState createState() => _MarkerManageState();
}

String filter;

class _MarkerManageState extends State<MarkerManage> {
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
                stream:
                    // (filter != "" && filter != null)
                    // ? FirebaseFirestore.instance
                    //     .collection("markers")
                    //     .where("role", isEqualTo: "USER")
                    //     .where('username', isEqualTo: filter)
                    //     .snapshots()
                    // :
                    FirebaseFirestore.instance
                        .collection("markers")
                        .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot markers = snapshot.data.docs[index];
                      return MarkerItem(
                        documentSnapshot: markers,
                        id: markers.id,
                        eventType: markers['eventType'],
                        createdName: markers['createdName'],
                        imageUrl: markers['imageUrl'],
                        createdOn: markers['createdOn'],
                        isActive: markers['isActive'],
                        namePoint: markers['namePoint'],
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
