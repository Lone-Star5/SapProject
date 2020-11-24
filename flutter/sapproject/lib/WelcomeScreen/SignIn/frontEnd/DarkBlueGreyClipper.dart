import 'package:flutter/material.dart';

class DarkBlueGrey extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height / 1.5);
    var firstControlPoint = new Offset(size.width / 6, size.height / 1.5);
    var firstEndPoint = new Offset(size.width / 2.85, size.height / 2);
    var secondControlPoint = new Offset(size.width / 2 + 40, size.height / 3);
    var secondEndPoint =
        new Offset(size.width - (size.width / 4), size.height / 1.75);

    var thirdControlPoint = new Offset(size.width - 20, size.height / 3);
    var thirdEndPoint = new Offset(size.width, size.height / 2);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    path.lineTo(size.width, size.height / 4);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
