import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  String _documentId = '';
  String _dateTime = '';
  Map _userOrder = {};
  String _tableNumber = '';
  int _total = 0;
  bool _donePayment = false;
  String _information = '';

  void getHistory({
    required String documentId,
    required String dateTime,
    required Map userOrder,
    required String tableNumber,
    required int total,
    required bool donePayment,
    required String information,
  }) {
    _documentId = documentId;
    _dateTime = dateTime;
    _userOrder = userOrder;
    _tableNumber = tableNumber;
    _total = total;
    _donePayment = donePayment;
    _information = information;

    notifyListeners();
  }

  String get documentId => _documentId;
  String get dateTime => _dateTime;
  Map get userOrder => _userOrder;
  String get tableNumber => _tableNumber;
  int get total => _total;
  bool get donePayment => _donePayment;
  String get information => _information;
}
