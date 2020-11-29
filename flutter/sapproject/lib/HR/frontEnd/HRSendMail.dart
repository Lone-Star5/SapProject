import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sapproject/HR/backend/HRText.dart';
import 'package:url_launcher/url_launcher.dart';

class HRSendMail {
  _launchMail(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void sendMail({BuildContext context, String sender}) {
    final _heightForCard = MediaQuery.of(context).size.height * 0.5;
    final _widthForCard = MediaQuery.of(context).size.width * 0.9;
    final TextEditingController _senderSub = TextEditingController();
    final TextEditingController _senderBody = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.blueGrey[900],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: SizedBox(
              height: _heightForCard,
              width: _widthForCard,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: _senderSub,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.white,
                            ),
                            contentPadding: EdgeInsets.only(left: 25.0),
                            hintText: HRText.HR_EMAIL_SUB,
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        maxLines: 7,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: _senderBody,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 15.0, top: 15),
                            hintText: HRText.HR_EMAIL_BODY,
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        child: TextButton(
                          onPressed: () => _launchMail(sender,
                              _senderSub.text.trim(), _senderBody.text.trim()),
                          child: Text(
                            HRText.HR_SEND_MAIL,
                            style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
