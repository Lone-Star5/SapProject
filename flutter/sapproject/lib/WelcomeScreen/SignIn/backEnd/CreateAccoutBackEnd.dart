import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sapproject/WelcomeScreen/SignIn/backEnd/AuthenticationClass.dart';

class CreateAccountBackEnd {
  void createAccount(
      {BuildContext context,
      String name,
      String phone,
      String dept,
      String email,
      String pass}) {
    context
        .read<AuthenticationService>()
        .signUp(email: email.trim(), password: pass.trim(), name: name.trim())
        .then((value) async {
      try {
        await FirebaseFirestore.instance.collection("Employee").add({
          "Name": name,
          "Phone": phone,
          "Department": dept,
          "Email": email,
        });
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        Fluttertoast.showToast(msg: e.message);
      }
    });
  }
}
