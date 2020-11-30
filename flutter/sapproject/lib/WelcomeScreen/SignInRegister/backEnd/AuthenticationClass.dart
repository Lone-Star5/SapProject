import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sapproject/main.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get getauthStateChanges => _firebaseAuth.authStateChanges();

  void signIn({String email, String password}) async {
    FirebaseFirestore.instance.collection("HR").get().then((value) {
      value.docs.forEach((element) {
        if (element['email'] == email) {
          AuthenticationWrapper.field = 1;
        }
      });
    });
    if (AuthenticationWrapper.field == 0) AuthenticationWrapper.field = 2;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      AuthenticationWrapper.field = 0;
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> signUp({String email, String password, String name}) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async =>
              await value.user.updateProfile(displayName: name));
      Fluttertoast.showToast(msg: "Your account has been created!");
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      Fluttertoast.showToast(msg: "You have Signed Out!");
      AuthenticationWrapper.field = 0;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    }
  }

  void resetPasswrod({String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: "Password reset mail has been sent to You!");
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    }
  }
}
