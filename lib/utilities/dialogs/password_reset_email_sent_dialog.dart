import 'package:flutter/material.dart';
import 'package:onfood/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content:
        'Kami sudah mengirimkan link reset password. Silahkan lihat email anda',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
