import 'package:flutter/material.dart';

class TableTextField extends StatelessWidget {
  /// Creates a [TableTextField].
  ///
  /// Filling the number into the order.
  /// The [numberController] argument must be not null.

  const TableTextField({super.key, required this.numberController});

  /// Filling the number in the TextField.
  final TextEditingController? numberController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            'Meja',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 55,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: numberController,
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'Nomor',
            ),
          ),
        )
      ],
    );
  }
}
