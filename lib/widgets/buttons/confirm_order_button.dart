import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/utilities/create_order.dart';
import 'package:onfood/utilities/dialogs/reward_dialog.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:provider/provider.dart';

final FirebaseCloudStorage _orderService = FirebaseCloudStorage();
final NumberFormat currency = NumberFormat("#,##0", 'ID');

class ConfirmOrderButton extends StatelessWidget {
  /// Creates a [ConfirmOrderButton].
  ///
  /// Confirmed the order.
  /// The [numberController] and [informationController] arguments must be
  /// not null.

  const ConfirmOrderButton({
    super.key,
    this.numberController,
    this.informationController,
  });

  /// Confirm a number from TextField.
  final TextEditingController? numberController;

  /// Confirm a information from TextField.
  final TextEditingController? informationController;

  @override
  Widget build(BuildContext context) {
    final OrdersProvider providerData = context.watch<OrdersProvider>();
    final int currentTotal = providerData.getTotal;
    final int discount = providerData.getDiscount;
    final Map<String, dynamic> userOrder = providerData.getUserOrders;
    final int total = currentTotal - ((currentTotal * discount) ~/ 100);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          fixedSize: const Size(double.infinity, 35),
        ),
        onPressed: () async {
          EasyLoading.show(status: 'Loading...', dismissOnTap: true);
          if (numberController!.text.isEmpty ||
              (numberController!.text == '0')) {
            EasyLoading.dismiss();
            const snackBar = SnackBar(
              duration: Duration(seconds: 1),
              content: Text('tolong masukkan nomor meja anda'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            final order = await createOrder(
              tableNumber: numberController!.text,
              order: userOrder,
              totalPayment: total,
              information: informationController!.text,
            );
            if (discount != 0) {
              providerData.coupon(inUsed: true);
            }
            int reward = await checkReward();

            if (reward != 0) {
              await createCoupon(
                documentId: order.documentId,
                userId: userId,
                reward: reward,
              );
              final userData = await _orderService.userData(
                ownerUserId: userId,
              );
              EasyLoading.dismiss();
              await showRewardDialog(
                context: context,
                username: userData.username,
                discount: reward,
              );
              EasyLoading.show(status: 'Loading...', dismissOnTap: true);
            }
            EasyLoading.showSuccess('Pesanan anda berhasil dibuat');
            EasyLoading.dismiss();
            providerData.pressingButton(pressButton: true);
            Future.delayed(
              const Duration(milliseconds: 1000),
              () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  homeRoute,
                  (route) => false,
                );
              },
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(text: 'Pesan'),
            CustomText(text: 'Rp.${currency.format(total)}')
          ],
        ),
      ),
    );
  }
}
