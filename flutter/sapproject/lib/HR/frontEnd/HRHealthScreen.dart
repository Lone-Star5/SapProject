import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sapproject/HR/backend/HRText.dart';
import 'package:sapproject/HR/backend/SearchService.dart';
import 'package:sapproject/HR/frontEnd/HRDrawer.dart';
import 'package:sapproject/HR/frontEnd/HRSendMail.dart';
import 'package:sapproject/HR/frontEnd/ViewHolderForHealth.dart';
import 'package:url_launcher/url_launcher.dart';

class HRHealthScreen extends StatefulWidget {
  @override
  _HRHealthScreenState createState() => new _HRHealthScreenState();
}

class _HRHealthScreenState extends State<HRHealthScreen> {
  var queryResultSet = [];
  var tempSearchStore = [];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: SafeArea(
            child: AppBar(
              shadowColor: Colors.black,
              backgroundColor: Colors.blueGrey,
              title: Center(
                child: Text(
                  HRText.HR_DASHBOARD,
                  style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        drawer: HRDrawer(),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: HRText.HR_HEALTH_SEARCH,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10.0),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element, context);
              }).toList())
        ]));
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((value) {
        value.docs.forEach((element) {
          queryResultSet.add(element);
        });
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        FirebaseFirestore.instance
            .collection("isCurrentHealth")
            .doc(element['email'])
            .get()
            .then((value) {
          if (element['name']
              .toString()
              .toLowerCase()
              .startsWith(capitalizedValue.toString().toLowerCase())) {
            setState(() {
              tempSearchStore.add(CustomStructure(
                  element,
                  DateTime.fromMicrosecondsSinceEpoch(
                      value['date'].microsecondsSinceEpoch),
                  value['status']));
            });
          }
        });
      });
    }
  }
}

Widget buildResultCard(CustomStructure data, context) {
  _launchCaller() async {
    String url = "tel:" + data.getDocumentSnapshot['phone'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  return InkWell(
    onDoubleTap: () {
      ViewHolderForHealth().getHealthView(
          context: context, email: data.getDocumentSnapshot['email']);
    },
    child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Text(
              data.getDocumentSnapshot['name'],
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(color: Colors.blueGrey, fontSize: 20)),
            )),
            ListTile(
              onTap: _launchCaller,
              leading: Icon(Icons.phone),
              title: Text(data.getDocumentSnapshot['phone'],
                  style: GoogleFonts.ubuntu(
                      textStyle:
                          TextStyle(color: Colors.blueGrey, fontSize: 20))),
            ),
            ListTile(
              onTap: () => HRSendMail().sendMail(
                  context: context, sender: data.getDocumentSnapshot['email']),
              leading: Icon(Icons.email),
              title: Text(data.getDocumentSnapshot['email'],
                  style: GoogleFonts.ubuntu(
                      textStyle:
                          TextStyle(color: Colors.blueGrey, fontSize: 20))),
            ),
            data.sickStatus == "sick" &&
                    DateTime.now().difference(data.getSickDate).inDays > 2
                ? ListTile(
                    leading: Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                    title: Text(
                        "Sick Since : ${data.getSickDate.toString().substring(0, 10)}"),
                  )
                : DateTime.now().difference(data.getSickDate).inDays > 2 &&
                        data.sickStatus != "sick"
                    ? ListTile(
                        leading: Icon(Icons.warning, color: Colors.yellow),
                        title: Text(
                            "Last Login : ${data.getSickDate.toString().substring(0, 10)}"),
                      )
                    : Container()
          ],
        )),
  );
}
