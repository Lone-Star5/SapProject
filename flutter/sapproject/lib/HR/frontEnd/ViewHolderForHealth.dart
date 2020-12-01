import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sapproject/HR/backend/HRText.dart';

class ViewHolderForHealth {
  List<DocumentSnapshot> _healthReportList;
  ViewHolderForHealth() {
    _healthReportList = List<DocumentSnapshot>();
  }
  void getHealthView({@required BuildContext context, @required String email}) {
    FirebaseFirestore.instance.collection("Health").get().then((value) {
      value.docs.forEach((element) {
        if (element['email'] == email) _healthReportList.add(element);
      });
      final _heightForCard = MediaQuery.of(context).size.height * 0.7;
      final _widthForCard = MediaQuery.of(context).size.width * 0.9;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: SizedBox(
                  height: _heightForCard,
                  width: _widthForCard,
                  child: Container(
                    color: Colors.transparent,
                    child: ListView.builder(
                        itemCount: _healthReportList.length,
                        itemBuilder: (context, index) =>
                            _ListTileCustom(_healthReportList[index])),
                  ),
                ));
          });
    });
  }
}

class _ListTileCustom extends StatelessWidget {
  final DocumentSnapshot _documentSnapshot;
  _ListTileCustom(this._documentSnapshot);
  @override
  Widget build(BuildContext context) {
    final double _cotainerHeight = MediaQuery.of(context).size.height * 0.35;
    final _calenderContainerHeight = MediaQuery.of(context).size.height * 0.06;
    Timestamp timeStamp = _documentSnapshot['date'];
    Icon _icon = Icon(
      Icons.emoji_emotions,
      color: Colors.green,
    );
    if (_documentSnapshot['status'] == "sick")
      _icon = Icon(
        Icons.sick,
        color: Colors.red,
      );
    //ViewHolder Container
    return Container(
      height: _cotainerHeight,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.grey[350], Colors.grey[500]]),
        borderRadius: BorderRadius.circular(10),
      ),
      //Widgets inside the ViewHolder Container
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin:
                const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            height: _calenderContainerHeight,
            child: Row(
              children: <Widget>[
                Container(
                  height: _calenderContainerHeight,
                  child: Image(
                      image: AssetImage('assets/images/info_calender.png')),
                ),
                VerticalDivider(
                  thickness: 1,
                  color: Colors.black,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 60),
                    child: Text(timeStamp.toDate().toString().substring(0, 10),
                        style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(fontSize: 20)))),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Row(
                children: [
                  Text(HRText.HR_HEALTH_STATUS,
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(fontSize: 20))),
                  Expanded(child: Divider(color: Colors.transparent)),
                  Text(_documentSnapshot['status'],
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(fontSize: 20))),
                  Container(
                    child: _icon,
                  ),
                ],
              )),
              Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Row(
                children: [
                  Text(HRText.HR_HEALTH_TRAVEL,
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(fontSize: 20))),
                  Expanded(child: Divider(color: Colors.transparent)),
                  Text(_documentSnapshot['travelling'].toString(),
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(fontSize: 20))),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Row(
                children: [
                  Text(HRText.HR_HEALTH_ILLNESS,
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(fontSize: 20))),
                  Expanded(child: Divider(color: Colors.transparent)),
                  Text(_documentSnapshot['illness'].toString(),
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(fontSize: 20))),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    HRText.HR_HEALTH_DESC,
                    style:
                        GoogleFonts.ubuntu(textStyle: TextStyle(fontSize: 15)),
                  ))),
          Expanded(
            child: SingleChildScrollView(
              child: Text(_documentSnapshot['description']),
            ),
          ),
        ],
      ),
    );
  }
}
