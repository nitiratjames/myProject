import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checkpoint/screens/widgets/marker/operation.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MarkerItem extends StatefulWidget {
  final String eventType;
  final String createdName;
  final String imageUrl;
  final Timestamp createdOn;
  final String role;
  final String id;
  final bool isActive;
  final String namePoint;
  final DocumentSnapshot documentSnapshot;

  MarkerItem({
    @required this.eventType,
    @required this.documentSnapshot,
    @required this.createdName,
    @required this.imageUrl,
    @required this.createdOn,
    @required this.role,
    @required this.id,
    @required this.isActive,
    @required this.namePoint,

  });

  @override
  _MarkerItemState createState() => _MarkerItemState();
}

class _MarkerItemState extends State<MarkerItem> {
  // bool status = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Icon(
                  Icons.person,
                  size: 50.0,
                  color: Colors.black54,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Row(
                    //   children: [
                    //     Column(
                    //       children: <Widget>[
                    //         Padding(
                    //           padding: const EdgeInsets.only(left: 8.0),
                    //           child: Text(
                    //             widget.namePoint,
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.white,
                    //               fontSize: 25,
                    //               fontFamily: 'Kanit',
                    //             ),
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(left: 8.0),
                    //           child: Text("${widget.createdName}",
                    //               style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 20,
                    //                 fontFamily: 'Kanit',
                    //               )),
                    //         )
                    //       ],
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     editStatus(widget.isActive, widget.id);
                  //   },
                  //   icon: widget.isActive
                  //       ? Icon(
                  //           Icons.clear,
                  //           color: Colors.red,
                  //           size: 40.0,
                  //         )
                  //       : Icon(
                  //           Icons.done,
                  //           size: 40.0,
                  //           color: Colors.greenAccent,
                  //         ),
                  // ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: <Widget>[
                  //     Switch(
                  //       activeColor: Colors.lightGreenAccent,
                  //       value: widget.createMarker,
                  //       onChanged: (val) {
                  //         toggleStatusCreatMarker(widget.createMarker, widget.id);
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // Container(
                  //   width: 80.0,
                  //   child: RaisedButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       '${widget.role}',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontFamily: 'Kanit',
                  //       ),
                  //     ),
                  //     textColor: Colors.white,
                  //     splashColor: Colors.red,
                  //     color: Colors.lightGreen,
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     deleteMarker(widget.documentSnapshot);
                  //   },
                  //   icon: Icon(
                  //     Icons.delete,
                  //     size: 40.0,
                  //     color: Colors.redAccent,
                  //   ),
                  // ),
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
