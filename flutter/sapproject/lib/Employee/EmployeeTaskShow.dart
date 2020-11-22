import 'package:flutter/material.dart';
import 'package:sapproject/Employee/frontEnd/TaskAssigned.dart';
import 'package:sapproject/Employee/frontEnd/TaskCompleted.dart';

class EmployeeTaskShow extends StatefulWidget {
  @override
  _EmployeeTaskShowState createState() => _EmployeeTaskShowState();
}

class _EmployeeTaskShowState extends State<EmployeeTaskShow> {
  List<Widget> _listOfWidget = [TaskAssigned(), TaskCompleted()];
  int _keyForListOfWidget = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listOfWidget[_keyForListOfWidget],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _keyForListOfWidget,
        unselectedLabelStyle: TextStyle(color: Colors.black),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
                color: Colors.black,
              ),
              label: "Tasks Assigned"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
              label: "Task Completed")
        ],
        onTap: (value) {
          setState(() {
            print("$_keyForListOfWidget");
            _keyForListOfWidget = value;
          });
        },
      ),
    );
  }
}
