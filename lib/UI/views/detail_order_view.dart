import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:onfood/widgets/custom_text.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/constructor/cloud_coupons.dart';
import 'package:onfood/services/cloud/constructor/cloud_orders.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/utilities/dialogs/reward_dialog.dart';
import 'package:onfood/utilities/fuzzy/reward_systems.dart';
import 'package:provider/provider.dart';

class DetailOrderView extends StatefulWidget {
  const DetailOrderView({super.key});

  @override
  State<DetailOrderView> createState() => _DetailOrderViewState();
}

class _DetailOrderViewState extends State<DetailOrderView> {
  int totalUserPayment = 0;

  final NumberFormat currency = NumberFormat("#,##0", 'ID');
  final DateTime now = DateTime.now();
  late final TextEditingController _informationController;
  late final TextEditingController _numberController;
  late final FirebaseCloudStorage _orderService;
  String get userId => AuthService().currentUser!.id;
  String get displayName => AuthService().currentUser!.displayName;

  Future<CloudOrders> createOrder({
    required BuildContext context,
    required String tableNumber,
    required Map order,
    required int totalPayment,
    required String information,
  }) async {
    final String date = DateFormat.yMMMMd('ID').format(now);
    final String time = DateFormat.Hm().format(now);
    final String dateTime = '$date, $time';
    final newOrder = await _orderService.createOrder(
      ownerUserId: userId,
      displayName: displayName,
      dateTimeOrder: dateTime,
      tableNumber: tableNumber,
      orders: order,
      totalPayment: totalPayment,
      donePayment: false,
      information: information,
    );

    return newOrder;
  }

  Future<int> checkReward() async {
    final historyUser = await _orderService.allorder(ownerUserId: userId);
    if (historyUser.length % 5 == 0) {
      for (var element in historyUser) {
        totalUserPayment += element.totalPayment;
      }

      int reward = rewardSystems(
        numberPurchasesInput: historyUser.length,
        totalSpendingInput: totalUserPayment,
      );
      return reward;
    } else {
      int reward = 0;

      return reward;
    }
  }

  Future<CloudCoupons> createCoupon({
    required String documentId,
    required String userId,
    required int reward,
  }) async {
    final newCoupon = await _orderService.createCoupon(
      documentId: documentId,
      ownerUserId: userId,
      reward: reward,
    );

    return newCoupon;
  }

  @override
  void initState() {
    _orderService = FirebaseCloudStorage();
    _informationController = TextEditingController();
    _numberController = TextEditingController();
    initializeDateFormatting();
    super.initState();
  }

  @override
  void dispose() {
    _informationController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final OrdersProvider providerData = context.watch<OrdersProvider>();
    final int currentTotal = providerData.getTotal;
    final int discount = providerData.getDiscount;
    final Map userOrder = providerData.getUserOrders;
    final String couponId = providerData.getCoupounId;
    final int total = currentTotal - ((currentTotal * discount) ~/ 100);
    List menuNames = [];
    List items = [];

    for (String menuName in userOrder.keys) {
      menuNames.add(menuName);
    }

    for (int item in userOrder.values) {
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
          'Pesanan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
              ),
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: userOrder.length,
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
                    ),
                  ],
                ),
              ),
            ),
            Container(
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
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text(
                            'Meja',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _numberController,
                            decoration: const InputDecoration(
                              isDense: true,
                              hintText: 'Nomor',
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: TextField(
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: _informationController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'Masukkan keterangan yang ingin disampaikan ke dapur. contoh: jus alpukat tidak pakai es.',
                          labelText: 'Keterangan',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text(
                            'Ingin menambah pesanan?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: const Text(
                            'Tambah',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 255, 166, 47),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  fixedSize: const Size(350, 35),
                ),
                onPressed: () async {
                  EasyLoading.show(status: 'Loading...');
                  if (_numberController.text.isEmpty ||
                      (_numberController.text == '0')) {
                    EasyLoading.dismiss();
                    const snackBar = SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('tolong masukkan nomor meja anda'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (discount != 0) {
                    await createOrder(
                      context: context,
                      tableNumber: _numberController.text,
                      order: userOrder,
                      totalPayment: total,
                      information: _informationController.text,
                    );
                    await _orderService.deleteCoupon(
                      documentId: couponId,
                    );
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
                  } else {
                    final order = await createOrder(
                      context: context,
                      tableNumber: _numberController.text,
                      order: userOrder,
                      totalPayment: currentTotal,
                      information: _informationController.text,
                    );
                    int reward = await checkReward();

                    if (reward != 0) {
                      createCoupon(
                        documentId: order.documentId,
                        userId: userId,
                        reward: reward,
                      );
                      final userData = await _orderService.userData(
                        ownerUserId: userId,
                      );
                      if (!context.mounted) return;
                      EasyLoading.dismiss();
                      await showRewardDialog(
                        context: context,
                        username: userData.username,
                        discount: reward,
                      );
                      EasyLoading.show(status: 'Loading...');
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
                    const CustomText(text: 'Pesan', fontType: 'normal'),
                    CustomText(
                      text: 'Rp.${currency.format(total)}',
                      fontType: 'normal',
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Informasi',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text.rich(
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Jika setiap 5 kali transaksi dengan total ',
                            ),
                            TextSpan(
                              text: 'keseluruhan transaksi pembelian mencapai ',
                            ),
                            TextSpan(
                              text:
                                  'minimal 150 ribu, maka akan memperoleh reward berupa kupon diskon.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
