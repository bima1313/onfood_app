import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/services/auth/auth_exceptions.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/constructor/users.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final FirebaseCloudStorage _usersService;
  late final TextEditingController _displayNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  List<String> checkUsername(Iterable<Users> usernames) {
    List<String> usernameData = [];
    for (int i = 0; i < usernames.length; i++) {
      final data = usernames.elementAt(i);
      usernameData.add(data.username);
    }

    return usernameData;
  }

  @override
  void initState() {
    _usersService = FirebaseCloudStorage();
    _displayNameController = TextEditingController();
    _phoneController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
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
                controller: _displayNameController,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Masukkan Nama anda',
                  labelText: 'Nama',
                ),
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Masukkan Username anda',
                  labelText: 'username',
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]|[a-z]|'))
                ],
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Masukkan Nomor Telepon anda',
                  labelText: 'nomor telepon',
                ),
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
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(350, 35),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const CustomText(text: 'Daftar', fontType: 'normal'),
                  onPressed: () async {
                    EasyLoading.show(status: 'Loading...');
                    Iterable<Users> usernames = await _usersService.users();
                    List<String> usernameData = checkUsername(usernames);

                    if (usernameData.contains(_usernameController.text)) {
                      EasyLoading.dismiss();
                      if (!context.mounted) return;
                      await showErrorDialog(
                        context,
                        'username yang anda masukkan sudah ada. Silahkan masukkan username yang lain',
                      );
                      const snackBar = SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('Akun gagal Dibuat'),
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      try {
                        await AuthService().createUser(
                          displayName: _displayNameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        await AuthService().sendEmailVerification();
                        final userId = AuthService().currentUser!.id;
                        await _usersService.createUser(
                          userId: userId,
                          username: _usernameController.text,
                          phoneNumber: _phoneController.text,
                        );
                        EasyLoading.dismiss();
                        const snackBar = SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('akun berhasil dibuat'),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } on EmailAlreadyInUseAuthException {
                        EasyLoading.dismiss();
                        if (!context.mounted) return;
                        await showErrorDialog(context, 'Email sudah Terdaftar');
                      } on InvalidEmailAuthException {
                        EasyLoading.dismiss();
                        if (!context.mounted) return;
                        await showErrorDialog(context, 'Invalid Email');
                      } on WeakPasswordAuthException {
                        EasyLoading.dismiss();
                        if (!context.mounted) return;
                        await showErrorDialog(context,
                            'Password yang anda masukkan lemah, Silahkan masukkan lebih kuat');
                      } on GenericAuthException {
                        EasyLoading.dismiss();
                        if (!context.mounted) return;
                        await showErrorDialog(context, 'Authentication Error');
                      }
                    }
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                },
                child: const Text(
                  'Sudah punya akun? Login sekarang',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
