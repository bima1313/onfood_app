import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/services/auth/auth_exceptions.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/constructor/users.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/utilities/dialogs/change_email_dialog.dart';
import 'package:onfood/utilities/dialogs/error_dialog.dart';

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
                          child: const CustomText(
                            text: 'Ganti Password',
                            fontType: 'normal',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            fixedSize: const Size(350, 35)),
                        onPressed: () async {
                          EasyLoading.show(status: 'Loading...');
                          try {
                            if (_displayNameController.text != '' &&
                                _displayNameController.text != ' ') {
                              Iterable<Users> usernames =
                                  await _usersService.users();
                              List<String> usernameData =
                                  checkUsername(usernames);
                              if (usernameData
                                  .contains(_usernameController.text)) {
                                EasyLoading.dismiss();
                                if (!context.mounted) return;
                                await showErrorDialog(
                                  context,
                                  'username yang anda masukkan sudah ada. Silahkan masukkan username yang lain',
                                );
                                const snackBar = SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text('Update Profile gagal'),
                                );
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                await AuthService().updateDisplayNameUser(
                                  displayName: _displayNameController.text,
                                );
                                await AuthService().updateEmailUser(
                                  newEmail: _emailController.text,
                                );
                                await _usersService.updateUserData(
                                  documentId: data.documentId,
                                  username: _usernameController.text,
                                  phoneNumber: _phoneNumberController.text,
                                );
                                if (_emailController.text != emailUser) {
                                  const String text1 =
                                      'Email Verifikasi sudah Terkirim ke email baru anda.';
                                  const String text2 =
                                      'silahkan cek dan verifikasi email baru anda untuk perubahan email';
                                  if (!context.mounted) return;
                                  EasyLoading.dismiss();
                                  await showChangingEmailDialog(
                                    context,
                                    '$text1 $text2',
                                  );
                                  EasyLoading.show(status: 'Loading...');
                                }
                                EasyLoading.showSuccess(
                                  'Update Profile Berhasil',
                                );
                                EasyLoading.dismiss();

                                Future.delayed(
                                  const Duration(milliseconds: 1000),
                                  () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      homeRoute,
                                      (route) => false,
                                    );
                                  },
                                );
                              }
                            } else {
                              EasyLoading.dismiss();
                              await showErrorDialog(
                                  context, 'Nama Pengguna tidak boleh kosong');
                            }
                          } on EmailAlreadyInUseAuthException {
                            EasyLoading.dismiss();
                            if (!context.mounted) return;
                            await showErrorDialog(
                                context, 'Email sudah Terdaftar');
                          } on RequiresRecentLoginAuthException {
                            EasyLoading.dismiss();
                            if (!context.mounted) return;
                            await showErrorDialog(context,
                                'Update Profile Gagal, Silahkan login ulang');
                          } on UserTokenExpiredAuthException {
                            EasyLoading.dismiss();
                            if (!context.mounted) return;
                            await showErrorDialog(context,
                                'Email sudah diganti, silahkan login ulang');
                          } on TooManyRequestsAuthException {
                            EasyLoading.dismiss();
                            if (!context.mounted) return;
                            await showErrorDialog(context,
                                'Terlalu banyak Request. Silahkan Coba lagi nanti');
                          } on GenericAuthException {
                            EasyLoading.dismiss();
                            if (!context.mounted) return;
                            await showErrorDialog(
                                context, 'Authentication Error');
                          }
                        },
                        child: const CustomText(
                          text: 'Edit Profile',
                          fontType: 'normal',
                        ),
                      ),
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
