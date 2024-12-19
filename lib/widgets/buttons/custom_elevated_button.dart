import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/constants/routes.dart';
import 'package:provider/provider.dart';

class CustomElevatedButton extends StatelessWidget {
  /// Creates a [CustomElevatedButton].
  ///
  /// Navigate the cart to [DetailOrderView].
  /// The [documentId] and [discount] arguments must be not null.

  const CustomElevatedButton({
    super.key,
    required this.discount,
    required this.documentId,
  });

  /// reading the discount from coupon data
  final int discount;

  /// reading the document id from coupon data
  final String documentId;

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
            fixedSize: const Size(double.infinity, 35)),
        onPressed: () async {
          if (items != 0) {
            if (providerData.couponInUsed == false || discount == 0) {
              providerData.usingCoupon(
                discount: discount,
                couponId: documentId,
              );
              providerData.coupon(inUsed: false);
            } else {
              providerData.usingCoupon(
                discount: 0,
                couponId: '',
              );
            }
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
                      ? CustomText(
                          text: ' = $items item',
                          fontWeight: FontWeight.bold,
                        )
                      : const CustomText(
                          text: ' = 0 item',
                          fontWeight: FontWeight.bold,
                        ),
                ],
              ),
              (totalBuy != 0)
                  ? CustomText(
                      text: 'Total = Rp.${currency.format(totalBuy)}',
                      fontWeight: FontWeight.bold,
                    )
                  : const CustomText(
                      text: 'Total = Rp.0',
                      fontWeight: FontWeight.bold,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
