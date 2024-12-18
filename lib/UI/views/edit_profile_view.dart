import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/constructor/users.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/widgets/buttons/edit_profile_button.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  late final FirebaseCloudStorage _usersService;

  String get userId => AuthService().currentUser!.id;
  String get displayNameUser => AuthService().currentUser!.displayName;
  String get emailUser => AuthService().currentUser!.email;

  @override
  void initState() {
    _usersService = FirebaseCloudStorage();
    _displayNameController = TextEditingController(text: displayNameUser);
    _usernameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController(text: emailUser);
    super.initState();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
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
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
              future: _usersService.userData(ownerUserId: userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final data = snapshot.data as Users;
                  _usernameController.text = data.username;
                  _phoneNumberController.text = data.phoneNumber;
                  return Column(
                    children: [
                      TextField(
                        controller: _displayNameController,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Nama anda',
                          labelText: 'Nama Pengguna',
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
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]|[a-z]|'))
                          ]),
                      TextField(
                        controller: _phoneNumberController,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            fixedSize: const Size(350, 35),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(changePasswordRoute);
                          },
                          child: const CustomText(text: 'Ganti Password'),
                        ),
                      ),
                      EditProfileButton(
                        documentId: data.documentId,
                        displayNameController: _displayNameController.text,
                        emailController: _emailController.text,
                        phoneNumberController: _phoneNumberController.text,
                        usernameController: _usernameController.text,
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
