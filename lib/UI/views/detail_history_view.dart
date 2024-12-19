import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onfood/utilities/casting_date_time.dart';
import 'package:onfood/widgets/buttons/cancel_order_button.dart';
import 'package:onfood/provider/history_provider.dart';
import 'package:onfood/widgets/order_widget.dart';
import 'package:provider/provider.dart';

class DetailHistoryView extends StatelessWidget {
  const DetailHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currency = NumberFormat("#,##0", 'ID');
    final HistoryProvider providerHistory = context.read<HistoryProvider>();
    final DateTime dateTime = providerHistory.dateTime.toDate();
    final width = MediaQuery.of(context).size.width;
    List menuNames = [];
    List items = [];

    for (var menuName in providerHistory.userOrder.keys) {
      menuNames.add(menuName);
    }

    for (var item in providerHistory.userOrder.values) {
      items.add(item);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Riwayat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Text(
                castToID(dateTime: dateTime),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const OrderWidget(
              isHistory: true,
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              margin: EdgeInsets.only(bottom: 16.0),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16.0),
              margin: const EdgeInsets.only(bottom: 64.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
              ),
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Meja :',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        providerHistory.tableNumber,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Keterangan: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    providerHistory.information,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        const Text(
                          'Total Harga = ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rp.${currency.format(providerHistory.total)}',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            (providerHistory.donePayment == false)
                ? const CancelOrderButton()
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
