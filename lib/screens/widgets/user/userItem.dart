import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checkpoint/screens/widgets/user/operation.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class UserItem extends StatefulWidget {
  final String username;
  final String email;
  final Timestamp createdOn;
  final String role;
  final String id;
  final bool isActive;
  final DocumentSnapshot documentSnapshot;

  UserItem({
    @required this.role,
    @required this.documentSnapshot,
    @required this.id,
    @required this.email,
    @required this.username,
    @required this.createdOn,
    @required this.isActive,
  });

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            // Container(
            //   height: 100,
            //   width: 150,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(10),
            //     // child: Image.network(
            //     //   widget.imageUrl,
            //     //   fit: BoxFit.cover,
            //     // ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${widget.email}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Kanit',
                                )),
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 70.0),
                          ),
                          IconButton(
                            onPressed: () {
                              editStatus(widget.isActive, widget.id);
                            },
                            icon: widget.isActive
                                ? Icon(
                                    Icons.clear,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    Icons.done,
                                    color: Colors.greenAccent,
                                  ),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteUser(widget.documentSnapshot);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
      ),
    );
  }
}
