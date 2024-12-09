import 'package:flutter/material.dart';
import 'package:onfood/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'ERROR',
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
