import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomStructure {
  DocumentSnapshot _documentSnapshot;
  DateTime _dateTime;
  String _status;
  CustomStructure(this._documentSnapshot, this._dateTime, this._status);
  DocumentSnapshot get getDocumentSnapshot => this._documentSnapshot;
  DateTime get getSickDate => this._dateTime;
  String get sickStatus => this._status;
}

class SearchService {
  Future<QuerySnapshot> searchByName(String searchField) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Employee').get();

    return snapshot;
  }
}

class TimeSickClass {
  int _total = 0, _times = 0;
  int get getTotal => this._total;
  int get getSickTimes => this._times;

  void setTotal(int x) {
    this._total = x;
  }

  void setSickTimes(int x) {
    this._times = x;
  }
}
