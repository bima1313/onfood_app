import 'package:flutter/material.dart';
import 'package:onfood/widgets/buttons/add_order_button.dart';
import 'package:onfood/widgets/total_order_widget.dart';

class OrderInformationWidget extends StatelessWidget {
  /// Creates a [OrderInformationWidget].
  ///
  /// The order informations about total payment and can changing the order.
  const OrderInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey, width: 0.8),
        ),
      ),
      width: width,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddOrderButton(),
            TotalOrderWidget(),
          ],
        ),
      ),
    );
  }
}
