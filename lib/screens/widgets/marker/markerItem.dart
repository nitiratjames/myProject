import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checkpoint/screens/widgets/marker/operation.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MarkerItem extends StatefulWidget {
  final String eventType;
  final String createdName;
  final String imageUrl;
  final Timestamp createdOn;
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
      child:Card(
          color: Colors.white70,
          child: Column(
            children: [
              new Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(widget.imageUrl)),
              new Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.eventType, style: Theme.of(context).textTheme.title),
                    Text(widget.createdName,
                        style: TextStyle(color: Colors.black.withOpacity(0.5))),
                    Text(widget.namePoint),
                  ],
                ),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )),
      // Container(
      //   width: double.infinity,
      //   child: Row(
      //     children: <Widget>[
      //     ],
      //   ),
      //   padding: EdgeInsets.all(10),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(10),
      //     color: Colors.grey,
      //   ),
      // ),
    );
  }
}
