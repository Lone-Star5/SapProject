import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sapproject/Employee/backEnd/StringText.dart';
import 'package:sapproject/Employee/backEnd/TaskCompletedBackEnd.dart';
import 'package:sapproject/Employee/frontEnd/ViewHolderTC.dart';

class TaskCompleted extends StatefulWidget {
  @override
  _TaskCompletedState createState() => _TaskCompletedState();
}

class _TaskCompletedState extends State<TaskCompleted> {
  final List<String> _justForDemo = ["Task8", "Task9", "Task17", "Task19"];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Heading for the Task Assigned Page
        Container(
          margin: const EdgeInsets.only(top: 25, left: 10),
          padding: const EdgeInsets.only(left: 15, top: 25),
          width: double.infinity,
          child: Text(StringText.HEADING_TASK_COMPLETED,
              textAlign: TextAlign.left,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: Colors.black, fontSize: 40))),
        ),
        //Grey Line which seperates the Heading from other Task
        Container(
            margin:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Divider(color: Colors.grey)),
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
                      key: ObjectKey(e), child: ViewHolderTaskCompleted(e)))
                  .toList(),
              onReorder: (oldIndex, newIndex) =>
                  TaskCompletedBackEnd().onReorder(oldIndex, newIndex),
            ),
          ),
        )
      ],
    );
  }
}
