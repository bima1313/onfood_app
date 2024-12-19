import 'package:flutter/material.dart';
import 'package:onfood/constants/hint_information_text.dart';

class InformationTextField extends StatelessWidget {
  /// Creates a [InformationTextField].
  ///
  /// Filling the information into the order.
  /// The  [informationController] argument must be not null.

  const InformationTextField({super.key, required this.informationController});

  /// Filling the information in the TextField.
  final TextEditingController? informationController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        controller: informationController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: '$hintInformationText $exampleInformationText',
          labelText: 'Keterangan',
        ),
      ),
    );
  }
}
