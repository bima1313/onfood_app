import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/services/cloud/constructor/users.dart';
import 'package:onfood/widgets/buttons/register_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
              RegisterButton(
                displayNameController: _displayNameController.text,
                emailController: _emailController.text,
                passwordController: _passwordController.text,
                phoneNumberController: _phoneController.text,
                usernameController: _usernameController.text,
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
