import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:onfood/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudOrders {
  final String documentId;
  final String userId;
  final String displayName;
  final String dateTime;
  final String tableNumber;
  final Map userOrders;
  final int totalPayment;
  final bool donePayment;
  final String information;

  const CloudOrders({
    required this.documentId,
    required this.userId,
    required this.displayName,
    required this.dateTime,
    required this.tableNumber,
    required this.userOrders,
    required this.totalPayment,
    required this.donePayment,
    required this.information,
  });

  CloudOrders.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[ownerUserIdFieldName],
        displayName = snapshot.data()[displayNameFieldName],
        dateTime = snapshot.data()[dateTimeFieldName],
        tableNumber = snapshot.data()[tableNumberFieldName],
        userOrders = snapshot.data()[userOrdersFieldName],
        totalPayment = snapshot.data()[totalPaymentFieldName],
        donePayment = snapshot.data()[donePaymentFieldName],
        information = snapshot.data()[informationFieldName];
}
