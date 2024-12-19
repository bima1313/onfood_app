import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/services/auth/auth_exceptions.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/utilities/dialogs/error_dialog.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          'Ganti Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Masukkan Password baru anda',
                  labelText: 'Password Baru',
                ),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Konfirmasi Password baru anda',
                  labelText: 'Konfirmasi Password Baru',
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  fixedSize: const Size(350, 35),
                ),
                onPressed: () async {
                  EasyLoading.show(status: 'Loading...', dismissOnTap: true);
                  if (_passwordController.text ==
                      _confirmPasswordController.text) {
                    try {
                      await AuthService().changePassword(
                        newPassword: _confirmPasswordController.text,
                      );
                      EasyLoading.dismiss();
                      const snackBar = SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('Ganti Password Berhasil'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } on RequiresRecentLoginAuthException {
                      EasyLoading.dismiss();
                      await showErrorDialog(context,
                          'Update Profile Gagal, Silahkan login ulang');
                    } on WeakPasswordAuthException {
                      EasyLoading.dismiss();
                      await showErrorDialog(context,
                          'Password yang anda masukkan lemah, Silahkan masukkan lebih kuat');
                    } on GenericAuthException {
                      EasyLoading.dismiss();
                      await showErrorDialog(context, 'Authentication Error');
                    }
                  } else {
                    EasyLoading.dismiss();
                    await showErrorDialog(context, 'ganti password gagal');
                  }
                },
                child: const CustomText(text: 'Ganti Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
