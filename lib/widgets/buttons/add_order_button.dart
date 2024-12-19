import 'package:flutter/material.dart';

class AddOrderButton extends StatelessWidget {
  /// Creates a [AddOrderButton].
  ///
  /// Displaying the button for changing the order.
  const AddOrderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            'Ingin menambah pesanan?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: const Text(
            'Tambah',
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 255, 166, 47),
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
