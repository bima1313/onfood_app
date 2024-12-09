import 'package:flutter/material.dart';
import 'package:onfood/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Keluar',
      content: 'Apakah anda yakin mau keluar?',
      optionBuilder: () => {
            'Batal': false,
            'Keluar': true,
          }).then(
    (value) => value ?? false,
  );
}
