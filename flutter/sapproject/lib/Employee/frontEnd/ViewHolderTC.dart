import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewHolderTaskCompleted extends StatelessWidget {
  final DocumentSnapshot _documentSnapshot;
  ViewHolderTaskCompleted(this._documentSnapshot);
  @override
  Widget build(BuildContext context) {
    final double _cotainerHeight = MediaQuery.of(context).size.height * 0.13;
    final double _clipperWidth = MediaQuery.of(context).size.width * 0.3;
    final double _clipperHeight = MediaQuery.of(context).size.height * 0.13;
    //ViewHolder Container, the basic layout of each tasks
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
          Expanded(child: Divider()),
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
              //The Widget which contains the Score :
              child: Center(
                //The Widget below is responsible for the drawing of circle
                child: CustomPaint(
                  painter: DrawCircle(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //Points Obtained
                      Text(
                        _documentSnapshot['taskpoints'].toString(),
                        style: GoogleFonts.ubuntu(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                      SizedBox(
                        width: _clipperWidth * 0.3,
                        child: Divider(color: Colors.white),
                      ),
                      //Total Points for The Task
                      Text(
                        _documentSnapshot['totalpoints'].toString(),
                        style: GoogleFonts.ubuntu(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ],
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

/*
    Custom Painter
    Used for drawing the cirlce inside the clip Path
    Contains the Points obtained!
*/

class DrawCircle extends CustomPainter {
  Paint _paint;
  DrawCircle() {
    _paint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 30.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
