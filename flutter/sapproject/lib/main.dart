import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sapproject/Employee/EmployeeTaskShow.dart';
import 'package:sapproject/HR/frontEnd/HRHealthScreen.dart';
import 'package:sapproject/WelcomeScreen/SignInRegister/SignIn.dart';
import 'package:sapproject/WelcomeScreen/SignInRegister/backEnd/AuthenticationClass.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp()
      .then((value) => runApp(SAPapp()))
      .catchError((onError) => print(onError.toString()));
}

class SAPapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<AuthenticationService>(
        create: (context) => AuthenticationService(FirebaseAuth.instance),
      ),
      StreamProvider(
        create: (context) =>
            context.read<AuthenticationService>().getauthStateChanges,
      ),
    ], child: MaterialApp(home: AuthenticationWrapper()));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  static int field = 0;
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      if (field == 1) {
        return HRHealthScreen();
      } else if (field == 2) return EmployeeTaskShow();
    }
    return SignIn();
  }
}
