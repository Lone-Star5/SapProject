import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sapproject/Employee/backEnd/StringText.dart';
import 'package:sapproject/Employee/backEnd/TaskAssignedBackEnd.dart';
import 'package:sapproject/Employee/frontEnd/ShowTaskInfo.dart';
import 'package:sapproject/Employee/frontEnd/ViewHolderTA.dart';
import 'package:sapproject/Employee/frontEnd/ViewHolderTC.dart';

class TaskCompleted extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldkey;
  TaskCompleted(this._scaffoldkey);
  @override
  _TaskCompletedState createState() => _TaskCompletedState(_scaffoldkey);
}

class _TaskCompletedState extends State<TaskCompleted> {
  final GlobalKey<ScaffoldState> _scaffoldkey;
  final List<String> _justForDemo = ["Task7", "Task8", "Task9", "Task14"];
  _TaskCompletedState(this._scaffoldkey);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _heightForHeading = MediaQuery.of(context).size.height * 0.17;
    return Column(
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
                margin: const EdgeInsets.only(left: 15),
                child: Text(StringText.HEADING_TASK_COMPLETED,
                    textAlign: TextAlign.left,
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
        /*
            ReOrderable ListView 
            - This widget is responsible for showing the Task Assigned to the employee by the project manager.
            - The employee can click on the task through InkWell widget and get more details regarding the same.
        */
        Expanded(
          //Parent Widget - Theme, so as to make the reorderable list view transparent when dragging the tasks.
          child: Theme(
            data: ThemeData(canvasColor: Colors.transparent),
            child: ReorderableListView(
              children: _justForDemo
                  .map((e) => InkWell(
                        key: ObjectKey(e),
                        child: ViewHolderTaskCompleted(e),
                        onTap: () => ShowTaskInfo().getCard(context),
                      ))
                  .toList(),
              onReorder: (oldIndex, newIndex) =>
                  TaskAssignedBackEnd().onReorder(oldIndex, newIndex),
            ),
          ),
        )
      ],
    );
  }
}
