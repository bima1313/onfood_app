import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/provider/history_provider.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/utilities/dialogs/delete_dialog.dart';
import 'package:provider/provider.dart';

class DetailHistoryView extends StatelessWidget {
  const DetailHistoryView({super.key});
  String get userId => AuthService().currentUser!.id;

  @override
  Widget build(BuildContext context) {
    final FirebaseCloudStorage orderService = FirebaseCloudStorage();
    final NumberFormat currency = NumberFormat("#,##0", 'ID');
    final HistoryProvider providerHistory = context.read<HistoryProvider>();
    final OrdersProvider providerData = context.read<OrdersProvider>();
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
                providerHistory.dateTime,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              margin: const EdgeInsets.only(bottom: 16.0),
              color: Colors.white,
              width: width,
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
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: providerHistory.userOrder.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            menuNames[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            items[index].toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16.0),
              margin: const EdgeInsets.only(bottom: 64.0),
              color: Colors.white,
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
                ? Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          fixedSize: const Size(350, 35)),
                      onPressed: () async {
                        if (providerHistory.documentId ==
                            providerData.getCoupounId) {
                          final cancelOrder = await showDeleteDialog(
                            context: context,
                            text1:
                                'Apakah anda yakin ingin membatalkan pesanan? ',
                            text2:
                                'jika dibatalkan, kupon yang telah diperoleh akan hilang.',
                          );
                          if (cancelOrder) {
                            EasyLoading.show(status: 'Loading...');
                            orderService.deleteOrder(
                              documentId: providerHistory.documentId,
                            );
                            orderService.cancelCoupon(
                              documentId: providerHistory.documentId,
                            );
                            EasyLoading.dismiss();
                            const snackBar = SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text('Pesanan anda dibatalkan'));
                            Future.delayed(
                              const Duration(seconds: 0),
                              () => ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar),
                            );
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
                        } else {
                          final cancelOrder = await showDeleteDialog(
                            context: context,
                            text1:
                                'Apakah anda yakin ingin membatalkan pesanan?',
                          );
                          if (cancelOrder) {
                            EasyLoading.show(status: 'Loading...');
                            orderService.deleteOrder(
                              documentId: providerHistory.documentId,
                            );
                            EasyLoading.dismiss();
                            const snackBar = SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text('Pesanan anda dibatalkan'));
                            Future.delayed(
                              const Duration(seconds: 0),
                              () => ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar),
                            );
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
                        }
                      },
                      child: const CustomText(
                        text: 'Batalkan Pemesanan',
                        fontType: 'normal',
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
