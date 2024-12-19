import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/provider/history_provider.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/utilities/dialogs/delete_dialog.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class CancelOrderButton extends StatelessWidget {
  /// Creates a [CancelOrderButton].
  ///
  /// Cancel the order.
  const CancelOrderButton({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseCloudStorage orderService = FirebaseCloudStorage();
    final HistoryProvider providerHistory = context.read<HistoryProvider>();
    final documentId = providerHistory.documentId;
    final ordersLength = providerHistory.userOrdersLength;
    final OrdersProvider providerData = context.read<OrdersProvider>();
    final couponId = providerData.getCoupounId;
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            fixedSize: const Size(350, 35)),
        onPressed: () async {
          final cancelOrder = await showDeleteDialog(
            context: context,
            text1: 'Apakah anda yakin ingin membatalkan pesanan?',
          );
          if (cancelOrder) {
            EasyLoading.show(
              status: 'Loading...',
              dismissOnTap: true,
            );
            orderService.deleteOrder(
              documentId: documentId,
            );
            if (documentId == couponId && ordersLength % 5 == 0) {
              orderService.cancelCoupon(
                documentId: documentId,
              );
            }
            providerData.coupon(inUsed: false);
            EasyLoading.dismiss();
            const snackBar = SnackBar(
                duration: Duration(seconds: 1),
                content: Text('Pesanan anda dibatalkan'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            Future.delayed(
              const Duration(seconds: 2),
              () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  homeRoute,
                  (route) => false,
                );
              },
            );
          }
        },
        child: const CustomText(text: 'Batalkan Pemesanan'),
      ),
    );
  }
}
