import 'package:flutter/material.dart';
import 'package:sapproject/Employee/EmployeeTaskShow.dart';
import 'package:sapproject/WelcomeScreen/SignIn/SignIn.dart';

void main() => runApp(SAPapp());

class SAPapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignIn());
  }
}
