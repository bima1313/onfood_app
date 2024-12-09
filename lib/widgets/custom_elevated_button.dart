import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/constants/routes.dart';
import 'package:provider/provider.dart';

class CustomElevatedButton extends StatelessWidget {
  final int discount;
  final String documentId;
  const CustomElevatedButton({
    super.key,
    required this.discount,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    final OrdersProvider providerData = context.watch<OrdersProvider>();
    final int items = providerData.getItems;
    final int totalBuy = providerData.getTotal;
    final NumberFormat currency = NumberFormat("#,##0", 'ID');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            fixedSize: const Size(350, 35)),
        onPressed: () {
          if (items != 0) {
            providerData.usingCoupon(
              discount: discount,
              couponId: documentId,
            );
            Navigator.of(context).pushNamed(detailOrderRoute);
          }
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white),
                  (items != 0)
                      ? CustomText(text: ' = $items item', fontType: 'normal')
                      : const CustomText(text: ' = 0 item', fontType: 'normal'),
                ],
              ),
              (totalBuy != 0)
                  ? CustomText(
                      text: 'Total = Rp.${currency.format(totalBuy)}',
                      fontType: 'normal',
                    )
                  : const CustomText(
                      text: 'Total = Rp.0',
                      fontType: 'normal',
                    )
            ],
          ),
        ),
      ),
    );
  }
}
