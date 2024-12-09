import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/services/auth/auth_exceptions.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/logo_onfood.png',
                width: 200,
                height: 200,
              ),
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
              TextField(
                controller: _passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Masukkan Password anda',
                  labelText: 'Password',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    fixedSize: const Size(350, 35),
                  ),
                  onPressed: () async {
                    EasyLoading.show(status: 'Loading...');
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    try {
                      await AuthService().logIn(
                        email: email,
                        password: password,
                      );
                      final user = AuthService().currentUser;
                      if (user?.isEmailVerified ?? false) {
                        // user's email is verified
                        EasyLoading.showSuccess('Login Berhasil');
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
                      } else {
                        // user's email is NOT verified
                        EasyLoading.dismiss();
                        if (!context.mounted) return;
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute,
                          (route) => false,
                        );
                      }
                    } on InvalidEmailAuthException {
                      EasyLoading.dismiss();
                      Future.delayed(
                        const Duration(seconds: 0),
                        () async {
                          await showErrorDialog(
                            context,
                            'Invalid Email',
                          );
                        },
                      );
                    } on InvalidCredentialAuthException {
                      EasyLoading.dismiss();
                      Future.delayed(
                        const Duration(seconds: 0),
                        () async {
                          await showErrorDialog(
                            context,
                            'Email dan Password salah',
                          );
                        },
                      );
                    } on GenericAuthException {
                      EasyLoading.dismiss();
                      Future.delayed(
                        const Duration(seconds: 0),
                        () async {
                          await showErrorDialog(
                            context,
                            'Authentication error',
                          );
                        },
                      );
                    }
                  },
                  child: const CustomText(text: 'Login', fontType: 'normal'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(resetPasswordRoute);
                },
                child: const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(350, 35),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Belum daftar? Daftar Disini!',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
