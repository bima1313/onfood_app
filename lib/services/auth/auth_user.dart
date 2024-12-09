import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String displayName;
  final String email;
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.displayName,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        displayName: user.displayName!,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
