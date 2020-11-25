import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sapproject/WelcomeScreen/SignIn/backEnd/AuthenticationClass.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _drawerWidth = MediaQuery.of(context).size.width * 0.7;
    final _accountSectionHeight = MediaQuery.of(context).size.height * 0.25;
    return new SizedBox(
      width: _drawerWidth,
      //Side Drawer Starts from here
      child: Drawer(
          child: Container(
        color: Colors.blueGrey[900],
        child: new Column(
          children: <Widget>[
            //Upper Portion responsible for account details
            Container(
              height: _accountSectionHeight,
              child: UserAccountsDrawerHeader(
                margin: const EdgeInsets.only(top: 20),
                currentAccountPicture: CircleAvatar(
                  foregroundColor: Colors.red,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/face_logo.png'),
                  ),
                ),
                decoration: new BoxDecoration(color: Colors.blueGrey[900]),
                accountEmail: Text(FirebaseAuth.instance.currentUser.email,
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(color: Colors.white, fontSize: 18),
                    )),
                accountName: Text(FirebaseAuth.instance.currentUser.displayName,
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ),
            ),
            //Divider between account details and option
            Divider(
              color: Colors.grey[700],
            ),
            // The Options present in drawer starts from here
            Padding(
              padding: const EdgeInsets.all(8.0),
              // ignore: todo
              //TODO: ADD MORE DETAILS HERE
              child: ListTile(
                leading: Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
                title: InkWell(
                  onTap: () => context.read<AuthenticationService>().signOut(),
                  child: new Text(
                    "Sign- Out",
                    style: GoogleFonts.ubuntu(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
