import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sapproject/WelcomeScreen/SignInRegister/backEnd/AuthenticationClass.dart';

class CreateAccountBackEnd {
  void createAccount(
      {BuildContext context,
      String name,
      String phone,
      String dept,
      String email,
      String pass,
      String category}) {
    context
        .read<AuthenticationService>()
        .signUp(email: email.trim(), password: pass.trim(), name: name.trim())
        .then((value) async {
      try {
        await FirebaseFirestore.instance.collection(category).add({
          "name": name,
          "phone": phone,
          "department": dept,
          "email": email,
          "searchKey": name[0]
        });
        Navigator.pop(context);
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        Fluttertoast.showToast(msg: e.message);
      }
    });
  }
}
