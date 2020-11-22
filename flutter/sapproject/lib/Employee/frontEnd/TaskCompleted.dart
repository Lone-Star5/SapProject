import 'package:flutter/material.dart';

class TaskCompleted extends StatefulWidget {
  @override
  _TaskCompletedState createState() => _TaskCompletedState();
}

class _TaskCompletedState extends State<TaskCompleted> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Hello World",
        style: TextStyle(color: Colors.blue, fontSize: 35),
      ),
    );
  }
}
