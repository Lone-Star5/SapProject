import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sapproject/Employee/EmployeeTaskShow.dart';
import 'package:sapproject/WelcomeScreen/SignInRegister/SignIn.dart';
import 'package:sapproject/main.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return EmployeeTaskShow();
      //return MyHomePage(firebaseUser.email);
    }
    return SignIn();
  }
}
