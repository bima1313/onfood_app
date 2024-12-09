import 'package:flutter/material.dart';
import 'package:onfood/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog({
  required BuildContext context,
  required String text1,
  String text2 = '',
}) {
  return showGenericDialog(
      context: context,
      title: 'Delete',
      content: text1 + text2,
      optionBuilder: () => {
            'Tidak': false,
            'Iya': true,
          }).then(
    (value) => value ?? false,
  );
}
