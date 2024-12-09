import 'package:onfood/services/auth/auth_user.dart';

abstract class Auth {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String displayName,
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
  Future<void> updateEmailUser({required String newEmail});
  Future<void> updateDisplayNameUser({required String displayName});
  Future<void> changePassword({required String newPassword});
}
