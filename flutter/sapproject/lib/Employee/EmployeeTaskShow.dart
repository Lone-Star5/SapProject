import 'package:flutter/material.dart';
import 'package:sapproject/Employee/frontEnd/SideDrawer.dart';
import 'package:sapproject/Employee/frontEnd/TaskAssigned.dart';
import 'package:sapproject/Employee/frontEnd/TaskCompleted.dart';

class EmployeeTaskShow extends StatefulWidget {
  @override
  _EmployeeTaskShowState createState() => _EmployeeTaskShowState();
}

class _EmployeeTaskShowState extends State<EmployeeTaskShow> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<Widget> _listOfWidget;
  int _keyForListOfWidget = 0;

  @override
  void initState() {
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _listOfWidget = [TaskAssigned(_scaffoldKey), TaskCompleted(_scaffoldKey)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      //Contains the drawer, the three bar icon, menu towards top left of the screen
      drawer: SideDrawer(),
      //Body containing two different widgets.
      body: _listOfWidget[_keyForListOfWidget],
      //Bottom Navigation Bar
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
