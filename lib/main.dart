import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onfood/UI/views/change_password_view.dart';
import 'package:onfood/UI/views/detail_history_view.dart';
import 'package:onfood/UI/views/detail_order_view.dart';
import 'package:onfood/UI/views/edit_profile_view.dart';
import 'package:onfood/UI/views/home_view.dart';
import 'package:onfood/UI/views/login_view.dart';
import 'package:onfood/UI/views/register_view.dart';
import 'package:onfood/UI/views/reset_password_view.dart';
import 'package:onfood/UI/views/verify_email_view.dart';
import 'package:onfood/app.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/provider/history_provider.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/utilities/config_loading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => OrdersProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'onfood',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 166, 47),
            primary: const Color.fromARGB(255, 255, 166, 47),
            secondary: const Color.fromARGB(255, 255, 201, 111),
          ),
          useMaterial3: true,
        ),
        home: const App(),
        builder: EasyLoading.init(),
        routes: {
          loginRoute: (context) => const LoginView(),
          resetPasswordRoute: (context) => const ResetPasswordView(),
          registerRoute: (context) => const RegisterView(),
          verifyEmailRoute: (context) => const VerifyEmailView(),
          homeRoute: (context) => const HomePage(),
          detailOrderRoute: (context) => const DetailOrderView(),
          detailHistoryRoute: (context) => const DetailHistoryView(),
          editProfileRoute: (context) => const EditProfileView(),
          changePasswordRoute: (context) => const ChangePasswordView(),
        },
      ),
    ),
  );
  configLoading();
}
