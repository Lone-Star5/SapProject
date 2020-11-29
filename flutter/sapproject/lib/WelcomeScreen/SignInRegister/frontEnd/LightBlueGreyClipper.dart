import 'package:flutter/material.dart';

class BlueGreyLight extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height / 2.125);
    var firstControlPoint = new Offset(size.width / 4, size.height / 1.5);
    var firstEndPoint = new Offset(size.width / 2, (size.height / 1.5) - 40);
    var secondControlPoint =
        new Offset(size.width - (size.width / 4), (size.height / 2) - 45);
    var secondEndPoint = new Offset(size.width, (size.height / 1.5) - 10);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 1.5);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
