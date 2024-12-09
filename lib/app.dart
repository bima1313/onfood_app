import 'package:flutter/material.dart';
import 'package:onfood/UI/views/home_view.dart';
import 'package:onfood/UI/views/login_view.dart';
import 'package:onfood/UI/views/verify_email_view.dart';
import 'package:onfood/services/auth/auth_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const HomePage();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
