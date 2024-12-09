import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/services/auth/auth_exceptions.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/utilities/dialogs/error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Tolong verifikasi Email anda:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        fixedSize: const Size(250, 35)),
                    onPressed: () async {
                      EasyLoading.show(status: 'Loading...');
                      try {
                        await AuthService().sendEmailVerification();
                        EasyLoading.dismiss();
                        const snackBar = SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('Email Verifikasi sudah Terkirim'),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } on TooManyRequestsAuthException {
                        EasyLoading.dismiss();
                        await showErrorDialog(context,
                            'Terlalu banyak Request. Silahkan Coba lagi nanti');
                      } on GenericAuthException {
                        EasyLoading.dismiss();
                        await showErrorDialog(context, 'Authentication Error');
                      }
                    },
                    child: const CustomText(
                      text: 'Kirim Email Verifikasi',
                      fontType: 'normal',
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      fixedSize: const Size(250, 35)),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child: const CustomText(
                    text: 'login',
                    fontType: 'normal',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
