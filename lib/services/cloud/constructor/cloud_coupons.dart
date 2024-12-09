import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:onfood/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudCoupons {
  final String documentId;
  final String userId;
  final int discount;

  const CloudCoupons({
    required this.documentId,
    required this.userId,
    required this.discount,
  });

  CloudCoupons.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[ownerUserIdFieldName],
        discount = snapshot.data()[discountFieldName];
}
