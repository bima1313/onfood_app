import 'package:flutter/material.dart';
import 'package:onfood/provider/history_provider.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/widgets/slidable_list.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatelessWidget {
  /// Creates a [OrderWidget].
  ///
  /// To display the current order before confirmed it.
  const OrderWidget({
    super.key,
    this.isHistory = false,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
  });

  /// For setting a [margin] and [padding] of `history view`.
  final bool isHistory;

  /// The margin for `history view`.
  ///
  /// Defaults to [BorderRadius.zero].
  final EdgeInsetsGeometry margin;

  /// The padding for `history view`.
  ///
  /// Defaults to [BorderRadius.zero].
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    Map<String, String> networkImage = {};
    Map<String, dynamic> userOrder = {};
    final double width = MediaQuery.of(context).size.width;
    if (isHistory) {
      final HistoryProvider providerHistory = context.read<HistoryProvider>();
      userOrder.addAll(providerHistory.userOrder);
    } else {
      final OrdersProvider providerData = context.watch<OrdersProvider>();
      networkImage.addAll(providerData.getMenuImages);
      userOrder.addAll(providerData.getUserOrders);
    }

    List menuNames = [];
    List items = [];

    for (String menuName in userOrder.keys) {
      menuNames.add(menuName);
    }

    for (int item in userOrder.values) {
      items.add(item);
    }
    return Container(
      padding: padding,
      margin: margin,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
      ),
      width: width,
      child: Padding(
        padding:
            (isHistory == false) ? const EdgeInsets.all(16.0) : EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: (isHistory == false)
                  ? const EdgeInsets.symmetric(vertical: 16.0)
                  : EdgeInsets.zero,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: userOrder.length,
                itemBuilder: (context, index) {
                  if (isHistory == false) {
                    return SlidableList(
                      networkImage: networkImage[menuNames[index]]!,
                      menuName: menuNames[index],
                      items: items[index],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          menuNames[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          '${items[index]}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
