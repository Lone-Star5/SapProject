import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sapproject/Employee/backEnd/ShowTaskBackEnd.dart';
import 'package:sapproject/Employee/backEnd/StringText.dart';

class ShowTaskInfo {
  void getCard(BuildContext context, DocumentSnapshot documentSnapshot) {
    final _heightForCard = MediaQuery.of(context).size.height * 0.7;
    final _widthForCard = MediaQuery.of(context).size.width * 0.9;
    final Timestamp timestamp = documentSnapshot['deadline'];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final _calenderContainerHeight =
              MediaQuery.of(context).size.height * 0.06;
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: _heightForCard,
                  width: _widthForCard,
                  //Column widget is responsible for containing all the other widgets of showother task
                  // Contains title, description, points, date and go to task button
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // The Row widget here is responsible for the Title and the space after it horizontally.
                      Row(children: [
                        Text(
                          StringText.SHOWINFO_TASK_TITLE,
                          style: GoogleFonts.ubuntu(
                            fontSize: 15,
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.transparent))
                      ]),
                      //This widget prints the title, whatever is assigned to the task.
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          documentSnapshot['title'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      //This widget is responsible for the description and the space after it.
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Row(children: [
                          Text(
                            StringText.SHOWINFO_TASK_DESC,
                            style: GoogleFonts.ubuntu(
                              fontSize: 15,
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            color: Colors.transparent,
                          ))
                        ]),
                      ),
                      //This is a scrollable widget, so that it contains all the description of the task in the screen.
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(documentSnapshot['description'],
                              style: GoogleFonts.ubuntu(
                                fontSize: 20,
                              )),
                        ),
                      ),
                      //This widget is resposnsible for showing the Points assigned to each Task
                      // Contains one text widget for "Points" and A Custom Paint for Circle
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(StringText.SHOWINFO_TASK_POINTS,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black, fontSize: 35)),
                            ),
                            CustomPaint(
                                painter: DrawCircle(),
                                child: Text(
                                  documentSnapshot['totalpoints'].toString(),
                                  style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                          color: Colors.blue[100],
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                ))
                          ],
                        ),
                      ),
                      // This widget is responsible for showing the date of the task
                      // It contains the icon, veritical divider and the date Text Widget
                      Container(
                        margin: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 20, top: 20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        height: _calenderContainerHeight,
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
                                            textStyle:
                                                TextStyle(fontSize: 25)))),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Widget for Showing Go To Task Button
                      // Upon clicking this button the designated webpage for the task will be opened
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: GestureDetector(
                          onTap: () {
                            ShowTaskBackEnd()
                                .launchInBrowser(documentSnapshot['link']);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            alignment: Alignment.center,
                            width: _widthForCard * 0.3,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Text("Go To Task",
                                style: GoogleFonts.ubuntu(
                                  color: Colors.blue,
                                  fontSize: 20,
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}

/*
  This is a Custom DrawCircle class, which extends CustomPainter
  It is responsible for drawing the small circle, besides Point, inside which
  Points are assigned.
  It extends "Custom Painer" class
*/

class DrawCircle extends CustomPainter {
  Paint _paint;
  DrawCircle() {
    _paint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 30.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
