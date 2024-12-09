import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:onfood/services/cloud/cloud_storage_constants.dart';

@immutable
class Users {
  final String documentId;
  final String userId;
  final String username;
  final String phoneNumber;

  const Users({
    required this.documentId,
    required this.userId,
    required this.username,
    required this.phoneNumber,
  });

  Users.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[ownerUserIdFieldName],
        username = snapshot.data()[usernameFieldName],
        phoneNumber = snapshot.data()[phoneNumberFieldName];
}
