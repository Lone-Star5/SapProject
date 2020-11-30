import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sapproject/WelcomeScreen/SignInRegister/CreateAccount.dart';
import 'package:sapproject/WelcomeScreen/SignInRegister/backEnd/AuthenticationClass.dart';
import 'package:sapproject/WelcomeScreen/SignInRegister/backEnd/SignInText.dart';
import 'package:sapproject/WelcomeScreen/SignInRegister/frontEnd/DarkBlueGreyClipper.dart';
import 'package:sapproject/WelcomeScreen/SignInRegister/frontEnd/LightBlueGreyClipper.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _resetPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double _passwordEntryWidth = MediaQuery.of(context).size.width * 0.55;
    final double _designContainerHeight =
        MediaQuery.of(context).size.height * 0.4;
    return Scaffold(
        //Responsible for showing the style of sign in page at the top with two different colors.
        body: Column(
      children: [
        Container(
            height: _designContainerHeight,
            child: Stack(children: <Widget>[
              ClipPath(
                clipper: BlueGreyLight(),
                child: Container(
                  color: Colors.blueGrey[400],
                ),
              ),
              ClipPath(
                clipper: DarkBlueGrey(),
                child: Container(
                  color: Colors.blueGrey[900],
                ),
              ),
            ])),
        Container(
          child: Text(
            SignInText.HEADING_SIGN_IN,
            style: GoogleFonts.montserrat(fontSize: 45, color: Colors.black),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Widget for Email ID Field
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  width: _passwordEntryWidth,
                  child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Email-ID");
                          return null;
                        } else
                          return null;
                      },
                      cursorColor: Colors.blueGrey,
                      decoration: InputDecoration(
                          labelText: SignInText.EMAIL_ID,
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              width: 1.0,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ))),
                ),
                Divider(
                  color: Colors.transparent,
                  thickness: 2,
                ),
                //Widget for Password Field
                Container(
                  width: _passwordEntryWidth,
                  child: TextFormField(
                      obscureText: true,
                      controller: _passController,
                      cursorColor: Colors.blueGrey,
                      decoration: InputDecoration(
                          labelText: SignInText.PASSWORD,
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              width: 1.0,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ))),
                ),
                Container(
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: TextFormField(
                                            cursorColor: Colors.blueGrey,
                                            controller: _resetPassController,
                                            decoration: InputDecoration(
                                                labelText: SignInText.EMAIL_ID,
                                                labelStyle: TextStyle(
                                                    color: Colors.blueGrey),
                                                fillColor: Colors.white,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.blueGrey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.email,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Colors.blueGrey,
                                                      Colors.blueGrey[900]
                                                    ])),
                                            child: TextButton(
                                              onPressed: () => context
                                                  .read<AuthenticationService>()
                                                  .resetPasswrod(
                                                      email:
                                                          _resetPassController
                                                              .text
                                                              .trim()),
                                              child: Text(
                                                  SignInText.RESET_BUTTON,
                                                  style: GoogleFonts.ubuntu(
                                                      color: Colors.white,
                                                      fontSize: 20)),
                                            )),
                                      ],
                                    )),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(SignInText.RESET_PASSWORD,
                          style: GoogleFonts.ubuntu(
                              color: Colors.blueGrey,
                              fontSize: 20,
                              decoration: TextDecoration.underline)),
                    )),
                //Widget responsible for showing the Sign In button on the screen
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: _passwordEntryWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.blueGrey, Colors.blueGrey[900]])),
                    child: TextButton(
                      onPressed: () {
                        context.read<AuthenticationService>().signIn(
                            email: _emailController.text.trim(),
                            password: _passController.text.trim());
                      },
                      child: Text(SignInText.HEADING_SIGN_IN,
                          style: GoogleFonts.ubuntu(
                              color: Colors.white, fontSize: 20)),
                    )),
                // Widget responsible for showing the New User button SignIn Page.
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: _passwordEntryWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.blueGrey, Colors.blueGrey[900]])),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateAccount()));
                      },
                      child: Text(SignInText.NEW_USER,
                          style: GoogleFonts.ubuntu(
                              color: Colors.white, fontSize: 20)),
                    ))
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
