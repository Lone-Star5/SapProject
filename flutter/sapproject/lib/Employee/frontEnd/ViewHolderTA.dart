import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewHolderTaskAssigned extends StatelessWidget {
  final DocumentSnapshot _documentSnapshot;
  ViewHolderTaskAssigned(this._documentSnapshot);
  @override
  Widget build(BuildContext context) {
    final double _cotainerHeight = MediaQuery.of(context).size.height * 0.13;
    final double _clipperWidth = MediaQuery.of(context).size.width * 0.3;
    final double _clipperHeight = MediaQuery.of(context).size.height * 0.13;
    Timestamp timestamp = _documentSnapshot['deadline'];
    //ViewHolder Container
    return Container(
      height: _cotainerHeight,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.grey[350], Colors.grey[500]]),
        borderRadius: BorderRadius.circular(10),
      ),
      //Widgets inside the ViewHolder Container
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
            child: Text(_documentSnapshot['title'],
                style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(color: Colors.black, fontSize: 26),
                )),
          ),
          //Divider between the Task heading and the dates inside each ViewHolder
          Expanded(
              child: Divider(
            color: Colors.transparent,
          )),
          //ClipPath used for drawing the curve with linear gradient.
          ClipPath(
            clipper: BackGroundClipper(),
            child: Container(
              height: _clipperHeight,
              width: _clipperWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      colors: [
                        Colors.grey[200],
                        Colors.grey[400],
                      ],
                      end: Alignment.bottomLeft)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    timestamp.toDate().toString().substring(0, 10),
                    style: GoogleFonts.ubuntu(
                        textStyle:
                            TextStyle(color: Colors.blue[800], fontSize: 20)),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*
    Custom ClipPath
    Used for drawing the curve design with gradient feature
    Contains the data as Date
*/
class BackGroundClipper extends CustomClipper<Path> {
  final radius = 5.0;
  @override
  Path getClip(Size size) {
    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 3.5 * radius, 0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
