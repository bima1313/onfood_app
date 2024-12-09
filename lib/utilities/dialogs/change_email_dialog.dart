import 'package:flutter/material.dart';
import 'package:onfood/utilities/dialogs/generic_dialog.dart';

Future<void> showChangingEmailDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'Pemberitahuan',
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
