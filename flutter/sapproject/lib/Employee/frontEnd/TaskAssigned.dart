import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sapproject/Employee/backEnd/StringText.dart';
import 'package:sapproject/Employee/backEnd/TaskAssignedBackEnd.dart';
import 'package:sapproject/Employee/frontEnd/ShowTaskInfo.dart';
import 'package:sapproject/Employee/frontEnd/ViewHolderTA.dart';

class TaskAssigned extends StatefulWidget {
  @override
  _TaskAssignedState createState() => _TaskAssignedState();
}

class _TaskAssignedState extends State<TaskAssigned> {
  final List<String> _justForDemo = ["Task1", "Task2", "Task3", "Task4"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Heading for the Task Assigned Page
        Container(
          margin: const EdgeInsets.only(top: 25, left: 10),
          padding: const EdgeInsets.only(left: 15, top: 25),
          width: double.infinity,
          child: Text(StringText.HEADING_TASK_ASSIGNED,
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
                        key: ObjectKey(e),
                        child: ViewHolderTaskAssigned(e),
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
