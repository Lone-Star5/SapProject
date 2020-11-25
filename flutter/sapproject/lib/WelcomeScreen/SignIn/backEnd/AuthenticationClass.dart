import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get getauthStateChanges => _firebaseAuth.authStateChanges();

  void signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(msg: "You have Signed In!");
    } on FirebaseAuthException catch (e) {
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

  void signOut() async {
    try {
      await _firebaseAuth.signOut();
      Fluttertoast.showToast(msg: "You have Signed Out!");
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    }
  }
}
