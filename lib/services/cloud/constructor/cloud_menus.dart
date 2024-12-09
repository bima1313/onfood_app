import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:onfood/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudMenus {
  final String documentId;
  final String menuName;
  final String category;
  final int price;
  final String imageUrl;

  const CloudMenus({
    required this.documentId,
    required this.menuName,
    required this.category,
    required this.price,
    required this.imageUrl,
  });

  CloudMenus.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        menuName = snapshot.data()[menuNameFieldName] as String,
        category = snapshot.data()[categoryFieldName],
        price = snapshot.data()[priceFieldName],
        imageUrl = snapshot.data()[imageUrlFieldName];
}
