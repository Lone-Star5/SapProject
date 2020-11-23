import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sapproject/Employee/backEnd/ShowTaskBackEnd.dart';
import 'package:sapproject/Employee/backEnd/StringText.dart';

class ShowTaskInfo {
  void getCard(BuildContext context) {
    final _heightForCard = MediaQuery.of(context).size.height * 0.7;
    final _widthForCard = MediaQuery.of(context).size.width * 0.9;
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(children: [
                        Text(
                          StringText.SHOWINFO_TASK_TITLE,
                          style: GoogleFonts.ubuntu(
                            fontSize: 15,
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.transparent))
                      ]),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Some Random Title To Be Fixed",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
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
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(StringText.JUST_FOR_DEMO_DESC,
                              style: GoogleFonts.ubuntu(
                                fontSize: 20,
                              )),
                        ),
                      ),
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
                                  "35",
                                  style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                          color: Colors.blue[100],
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                ))
                          ],
                        ),
                      ),
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
                                    child: Text("26-12-2020",
                                        style: GoogleFonts.ubuntu(
                                            textStyle:
                                                TextStyle(fontSize: 25)))),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: GestureDetector(
                          onTap: () {
                            ShowTaskBackEnd().launchInBrowser(
                                "https://en.wikipedia.org/wiki/Tiger");
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
