import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/services/auth/auth_exceptions.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Masukkan Email anda',
                labelText: 'Email',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(350, 35),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () async {
                  EasyLoading.show(status: 'Loading...', dismissOnTap: true);
                  final email = _emailController.text;
                  try {
                    await AuthService().sendPasswordReset(toEmail: email);
                    EasyLoading.dismiss();
                    await showPasswordResetSentDialog(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  } on InvalidEmailAuthException {
                    EasyLoading.dismiss();
                    const snackBar = SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Invalid Email'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } on GenericAuthException {
                    EasyLoading.dismiss();
                    const snackBar = SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Authentication Error'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const CustomText(text: 'Reset Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
