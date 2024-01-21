import 'package:flutter/material.dart';

class Calendar extends ChangeNotifier {
  DateTime now = DateTime.now().toUtc();
  late DateTime _selectedDate = DateTime.utc(now.year, now.month, now.day);

  DateTime get selectedDate => _selectedDate;

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
