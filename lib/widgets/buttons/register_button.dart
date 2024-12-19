import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onfood/services/auth/auth_exceptions.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/constructor/users.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/utilities/check_username.dart';
import 'package:onfood/utilities/dialogs/error_dialog.dart';
import 'package:onfood/widgets/custom_text.dart';

final FirebaseCloudStorage _usersService = FirebaseCloudStorage();

class RegisterButton extends StatelessWidget {
  /// Creates a [EditProfileButton].
  ///
  ///
  /// The [displayNameController], [emailController], [passwordController]
  /// [phoneNumberController] and [usernameController] arguments
  /// must be not null.
  const RegisterButton({
    super.key,
    required this.displayNameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneNumberController,
    required this.usernameController,
  });

  /// The input for display name.
  final String displayNameController;

  /// The input for email.
  final String emailController;

  /// The input for password.
  final String passwordController;

  /// The input for phone number.
  final String phoneNumberController;

  /// The input for username.
  final String usernameController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(350, 35),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: const CustomText(text: 'Daftar'),
        onPressed: () async {
          EasyLoading.show(status: 'Loading...', dismissOnTap: true);
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
              content: Text('Akun gagal Dibuat'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            try {
              await AuthService().createUser(
                displayName: displayNameController,
                email: emailController,
                password: passwordController,
              );
              await AuthService().sendEmailVerification();
              final userId = AuthService().currentUser!.id;
              await _usersService.createUser(
                userId: userId,
                username: usernameController,
                phoneNumber: phoneNumberController,
              );
              EasyLoading.dismiss();
              const snackBar = SnackBar(
                duration: Duration(seconds: 1),
                content: Text('akun berhasil dibuat'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } on EmailAlreadyInUseAuthException {
              EasyLoading.dismiss();
              await showErrorDialog(context, 'Email sudah Terdaftar');
            } on InvalidEmailAuthException {
              EasyLoading.dismiss();
              await showErrorDialog(context, 'Invalid Email');
            } on WeakPasswordAuthException {
              EasyLoading.dismiss();
              await showErrorDialog(context,
                  'Password yang anda masukkan lemah, Silahkan masukkan lebih kuat');
            } on GenericAuthException {
              EasyLoading.dismiss();
              await showErrorDialog(context, 'Authentication Error');
            }
          }
        },
      ),
    );
  }
}
