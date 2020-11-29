import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sapproject/Employee/backEnd/StringText.dart';
import 'package:sapproject/Employee/backEnd/TaskAssignedBackEnd.dart';
import 'package:sapproject/Employee/frontEnd/MessageCard.dart';
import 'package:sapproject/Employee/frontEnd/ShowTaskInfo.dart';
import 'package:sapproject/Employee/frontEnd/ViewHolderTA.dart';

class TaskAssigned extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldkey;
  TaskAssigned(this._scaffoldkey);
  @override
  _TaskAssignedState createState() => _TaskAssignedState(_scaffoldkey);
}

class _TaskAssignedState extends State<TaskAssigned> {
  final GlobalKey<ScaffoldState> _scaffoldkey;
  List<DocumentSnapshot> _listOfTasks, _listOfMessages;
  _TaskAssignedState(this._scaffoldkey);
  @override
  void initState() {
    super.initState();
    _listOfMessages = List<DocumentSnapshot>();
    _listOfTasks = List<DocumentSnapshot>();
  }

  @override
  Widget build(BuildContext context) {
    final _heightForHeading = MediaQuery.of(context).size.height * 0.17;
    final _heightForMessageCard = MediaQuery.of(context).size.height * 0.14;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Heading for the Task Assigned Page
        Container(
          height: _heightForHeading,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, top: 25),
          child: Row(
            children: [
              InkWell(
                onTap: () => _scaffoldkey.currentState.openDrawer(),
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ),
              //Text For Heading
              Container(
                margin: const EdgeInsets.only(left: 75),
                child: Text(StringText.DASHBOARD_HEADING,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 40))),
              ),
            ],
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.black, Colors.blueGrey])),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(StringText.SHOWINFO_MESSAGE,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 35,
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20),
              width: double.infinity,
              height: _heightForMessageCard,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Message")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("No Messages");
                  }
                  _listOfMessages = snapshot.data.documents;
                  _listOfMessages.removeWhere((element) =>
                      element['reciever'] !=
                      FirebaseAuth.instance.currentUser.email);
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _listOfMessages.length,
                      itemBuilder: (context, index) =>
                          MessageCard(_listOfMessages[index]));
                },
              ),
            ),
          ],
        ),
        Container(
            margin:
                const EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 15),
            child: Text(StringText.HEADING_TASK_ASSIGNED,
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 35,
                ))),
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        /*
            ReOrderable ListView 
            - This widget is responsible for showing the Task Assigned to the employee by the project manager.
            - The employee can click on the task through InkWell widget and get more details regarding the same.
        */
        Expanded(
          //Parent Widget - Theme, so as to make the reorderable list view transparent when dragging the tasks.
          child: Theme(
            data: ThemeData(canvasColor: Colors.transparent),
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Task").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Text("Loading!...");
                  else {
                    _listOfTasks = snapshot.data.documents;
                    _listOfTasks.removeWhere((element) =>
                        element['employee'] !=
                            FirebaseAuth.instance.currentUser.email ||
                        element['completed'] == true);
                    return ReorderableListView(
                      children: _listOfTasks
                          .map((e) => InkWell(
                                key: ObjectKey(e),
                                child: ViewHolderTaskAssigned(e),
                                onTap: () => ShowTaskInfo().getCard(context, e),
                              ))
                          .toList(),
                      onReorder: (oldIndex, newIndex) =>
                          TaskAssignedBackEnd().onReorder(oldIndex, newIndex),
                    );
                  }
                }),
          ),
        )
      ],
    );
  }
}
