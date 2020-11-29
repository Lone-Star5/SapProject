import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sapproject/Employee/backEnd/StringText.dart';

class MessageCard extends StatelessWidget {
  final DocumentSnapshot _documentSnapshot;
  MessageCard(this._documentSnapshot);
  @override
  Widget build(BuildContext context) {
    final _widthForCard = MediaQuery.of(context).size.width * 0.4;
    final _heightForInfoOfCard = MediaQuery.of(context).size.height * 0.6;
    final _widthForInfoOfCard = MediaQuery.of(context).size.width * 0.8;
    final _calenderContainerHeight = MediaQuery.of(context).size.height * 0.06;
    Timestamp timestamp = _documentSnapshot['date'];
    return Container(
      width: _widthForCard,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white),
          color: Colors.blueGrey),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.transparent,
                ),
              ),
              Container(
                child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .runTransaction((Transaction myTransaction) async {
                          myTransaction.delete(_documentSnapshot.reference);
                        });
                      } catch (onError) {
                        print(onError.toString());
                      }
                    }),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 2, right: 2),
            margin: const EdgeInsets.only(left: 2),
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.white,
                    child: SizedBox(
                      height: _heightForInfoOfCard,
                      width: _widthForInfoOfCard,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 20, top: 20),
                        child: Column(
                          children: [
                            Container(
                              height: _calenderContainerHeight,
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 20, top: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Image(
                                        image: AssetImage(
                                            'assets/images/info_calender.png')),
                                  ),
                                  VerticalDivider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Container(
                                          child: Text(
                                              timestamp
                                                  .toDate()
                                                  .toString()
                                                  .substring(0, 10),
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                      fontSize: 25)))),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(children: [
                              Text(
                                StringText.SHOWINFO_CARD_SENDER,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                ),
                              ),
                              Expanded(
                                  child: Divider(color: Colors.transparent))
                            ]),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                _documentSnapshot['sender'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(children: [
                                Text(
                                  StringText.SHOWINFO_CARD_MESSAGE,
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 15,
                                  ),
                                ),
                                Expanded(
                                    child: Divider(color: Colors.transparent))
                              ]),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(_documentSnapshot['message'],
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 20,
                                    )),
                              ),
                            ),
                            Container(
                              child: TextButton(
                                  child: Text(
                                    StringText.CLOSE_SHOWINFO_CARD,
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.blue, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.of(context).pop()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              child: Text(
                _documentSnapshot['message'],
                style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
