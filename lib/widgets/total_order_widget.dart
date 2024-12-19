import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:provider/provider.dart';

class TotalOrderWidget extends StatelessWidget {
  /// Creates a [TotalOrderWidget].
  ///
  /// Display the information about `total`, `discount` and `total payment`.
  const TotalOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersProvider providerData = context.watch<OrdersProvider>();
    final NumberFormat currency = NumberFormat("#,##0", 'ID');
    final int currentTotal = providerData.getTotal;
    final int discount = providerData.getDiscount;
    final int total = currentTotal - ((currentTotal * discount) ~/ 100);

    return Column(
      children: [
        const Divider(height: 32.0, color: Colors.grey),
        (discount != 0)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Selamat. Anda mendapatkan kupon diskon makan sebesar $discount%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const Padding(padding: EdgeInsets.only(bottom: 8.0)),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Rp.${currency.format(currentTotal)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Diskon',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${currency.format(discount)}%',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 32.0, color: Colors.grey),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp.${currency.format(total)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
