import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sapproject/Employee/backEnd/TaskAssignedBackEnd.dart';

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
        Text("To Be Done List View",
            style: GoogleFonts.ubuntu(
                textStyle: TextStyle(color: Colors.red, fontSize: 25))),
        Expanded(
          child: ReorderableListView(
            children: _justForDemo
                .map((e) => InkWell(
                    key: ObjectKey(e),
                    child: Text(e,
                        style: GoogleFonts.ubuntu(
                            textStyle:
                                TextStyle(color: Colors.blue, fontSize: 20)))))
                .toList(),
            onReorder: (oldIndex, newIndex) =>
                TaskAssignedBackEnd().onReorder(oldIndex, newIndex),
          ),
        )
      ],
    );
  }
}
