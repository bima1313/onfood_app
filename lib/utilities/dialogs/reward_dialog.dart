import 'package:flutter/material.dart';
import 'package:onfood/utilities/dialogs/generic_dialog.dart';

Future<void> showRewardDialog({
  required BuildContext context,
  required String username,
  required int discount,
}) {
  return showGenericDialog<void>(
    context: context,
    title: 'Pemberitahuan',
    content:
        'Selamat, $username. Anda berhak mendapatkan kupon diskon makan sebesar $discount%. Dan kupon akan otomatis terpakai pada pembelian selanjutnya',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
