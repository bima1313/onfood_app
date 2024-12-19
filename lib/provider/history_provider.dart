import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  bool _donePayment = false;
  int _length = 0;
  int _total = 0;
  Map<String, dynamic> _userOrder = {};
  String _documentId = '';
  String _tableNumber = '';
  String _information = '';
  Timestamp _dateTime = Timestamp.now();

  void getHistory({
    required String documentId,
    required Timestamp dateTime,
    required Map<String, dynamic> userOrder,
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

  void ordersLength({required int length}) {
    _length = length;

    notifyListeners();
  }

  bool get donePayment => _donePayment;
  int get userOrdersLength => _length;
  int get total => _total;
  Map<String, dynamic> get userOrder => _userOrder;
  String get information => _information;
  String get documentId => _documentId;
  String get tableNumber => _tableNumber;
  Timestamp get dateTime => _dateTime;
}
