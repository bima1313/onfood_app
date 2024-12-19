import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/services/auth/auth_exceptions.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/constructor/users.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/utilities/check_username.dart';
import 'package:onfood/utilities/dialogs/change_email_dialog.dart';
import 'package:onfood/utilities/dialogs/error_dialog.dart';
import 'package:onfood/widgets/custom_text.dart';

final FirebaseCloudStorage _usersService = FirebaseCloudStorage();
String get emailUser => AuthService().currentUser!.email;

class EditProfileButton extends StatelessWidget {
  /// Creates a [EditProfileButton].
  ///
  ///
  /// The [documentId], [displayNameController], [emailController],
  /// [phoneNumberController] and [usernameController] arguments
  /// must be not null.

  const EditProfileButton({
    super.key,
    required this.documentId,
    required this.displayNameController,
    required this.emailController,
    required this.phoneNumberController,
    required this.usernameController,
  });

  final String documentId;

  /// The input for display name.
  final String displayNameController;

  /// The input for email.
  final String emailController;

  /// The input for phone number.
  final String phoneNumberController;

  /// The input for username.
  final String usernameController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          fixedSize: const Size(350, 35)),
      onPressed: () async {
        EasyLoading.show(
          status: 'Loading...',
          dismissOnTap: true,
        );
        try {
          if (displayNameController != '' && displayNameController != ' ') {
            Iterable<Users> usernames = await _usersService.users();
            List<String> usernameData = checkUsername(usernames);
            if (usernameData.contains(usernameController)) {
              EasyLoading.dismiss();
              await showErrorDialog(
                context,
                'username yang anda masukkan sudah ada. Silahkan masukkan username yang lain',
              );
              const snackBar = SnackBar(
                duration: Duration(seconds: 1),
                content: Text('Update Profile gagal'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              await AuthService().updateDisplayNameUser(
                displayName: displayNameController,
              );
              await AuthService().updateEmailUser(
                newEmail: emailController,
              );
              await _usersService.updateUserData(
                documentId: documentId,
                username: usernameController,
                phoneNumber: phoneNumberController,
              );
              if (emailController != emailUser) {
                const String text1 =
                    'Email Verifikasi sudah Terkirim ke email baru anda.';
                const String text2 =
                    'silahkan cek dan verifikasi email baru anda untuk perubahan email';
                EasyLoading.dismiss();
                await showChangingEmailDialog(
                  context,
                  '$text1 $text2',
                );
                EasyLoading.show(
                  status: 'Loading...',
                  dismissOnTap: true,
                );
              }
              EasyLoading.showSuccess(
                'Update Profile Berhasil',
              );
              EasyLoading.dismiss();

              Future.delayed(
                const Duration(milliseconds: 1000),
                () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    homeRoute,
                    (route) => false,
                  );
                },
              );
            }
          } else {
            EasyLoading.dismiss();
            await showErrorDialog(context, 'Nama Pengguna tidak boleh kosong');
          }
        } on EmailAlreadyInUseAuthException {
          EasyLoading.dismiss();
          await showErrorDialog(context, 'Email sudah Terdaftar');
        } on RequiresRecentLoginAuthException {
          EasyLoading.dismiss();
          await showErrorDialog(
              context, 'Update Profile Gagal, Silahkan login ulang');
        } on UserTokenExpiredAuthException {
          EasyLoading.dismiss();
          await showErrorDialog(
              context, 'Email sudah diganti, silahkan login ulang');
        } on TooManyRequestsAuthException {
          EasyLoading.dismiss();
          await showErrorDialog(
              context, 'Terlalu banyak Request. Silahkan Coba lagi nanti');
        } on GenericAuthException {
          EasyLoading.dismiss();
          await showErrorDialog(context, 'Authentication Error');
        }
      },
      child: const CustomText(text: 'Edit Profile'),
    );
  }
}
