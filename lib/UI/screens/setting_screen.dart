import 'package:flutter/material.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/constructor/users.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/utilities/dialogs/logout_dialog.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  String get userId => AuthService().currentUser!.id;
  String get displayNameUser => AuthService().currentUser!.displayName;

  @override
  Widget build(BuildContext context) {
    final OrdersProvider providerData = context.watch<OrdersProvider>();
    final FirebaseCloudStorage userService = FirebaseCloudStorage();
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: userService.userData(ownerUserId: userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final data = snapshot.data as Users;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      displayNameUser,
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(data.username),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          fixedSize: const Size(350, 35)),
                      onPressed: () {
                        Navigator.of(context).pushNamed(editProfileRoute);
                      },
                      child: const CustomText(
                        text: 'Edit Profile',
                        fontType: 'normal',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        fixedSize: const Size(350, 35)),
                    onPressed: () async {
                      final shouldLogout = await showLogOutDialog(context);
                      if (shouldLogout) {
                        providerData.reset();
                        AuthService().logOut();
                        if (!context.mounted) return;
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (route) => false,
                        );
                      }
                    },
                    child: const CustomText(
                      text: 'Keluar',
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
          },
        ),
      ),
    );
  }
}
