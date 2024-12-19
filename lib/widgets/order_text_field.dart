import 'package:flutter/material.dart';
import 'package:onfood/widgets/information_text_field.dart';
import 'package:onfood/widgets/table_text_field.dart';

class OrderTextField extends StatelessWidget {
  /// Creates a [OrderTextField].
  ///
  /// Filling a number and information into the order.
  /// The [numberController] and [informationController] arguments must be
  /// not null.
  const OrderTextField({
    super.key,
    required this.numberController,
    required this.informationController,
  });

  /// Filling the number in the TextField.
  final TextEditingController? numberController;

  /// Filling the information in the TextField.
  final TextEditingController? informationController;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey, width: 0.8),
        ),
      ),
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableTextField(numberController: numberController),
            InformationTextField(informationController: informationController),
          ],
        ),
      ),
    );
  }
}
