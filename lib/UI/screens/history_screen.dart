import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/provider/history_provider.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/constructor/cloud_coupons.dart';
import 'package:onfood/services/cloud/constructor/cloud_orders.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String get userId => AuthService().currentUser!.id;
  late final FirebaseCloudStorage _orderService;

  @override
  void initState() {
    _orderService = FirebaseCloudStorage();
    super.initState();
  }

  Future<List> getData() async {
    final coupons = await _orderService.allCoupon();
    final allOrder = await _orderService.allorder(ownerUserId: userId);

    return [coupons, allOrder];
  }

  @override
  Widget build(BuildContext context) {
    final HistoryProvider providerHistory = context.watch<HistoryProvider>();
    final OrdersProvider providerdata = context.watch<OrdersProvider>();
    final NumberFormat currency = NumberFormat("#,##0", 'ID');
    int discount;
    String documentId;

    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data as List;
            final getCoupon = data[0] as Iterable<CloudCoupons>;
            final userOrders = data[1] as Iterable<CloudOrders>;
            final couponData = getCoupon.where(
              (element) => element.userId == userId,
            );
            if (couponData.isNotEmpty) {
              discount = couponData.first.discount;
              documentId = couponData.first.documentId;
            } else {
              discount = 0;
              documentId = '';
            }
            if (userOrders.isNotEmpty) {
              return ListView.builder(
                itemCount: userOrders.length,
                itemBuilder: (context, index) {
                  final CloudOrders order = userOrders.elementAt(index);
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.userOrders.keys.first,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          order.dateTime,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'lihat selengkapnya',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    trailing: Text(
                      'Rp.${currency.format(order.totalPayment)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () {
                      providerHistory.getHistory(
                        documentId: order.documentId,
                        dateTime: order.dateTime,
                        userOrder: order.userOrders,
                        tableNumber: order.tableNumber,
                        total: order.totalPayment,
                        donePayment: order.donePayment,
                        information: order.information,
                      );
                      providerdata.usingCoupon(
                        discount: discount,
                        couponId: documentId,
                      );
                      Navigator.of(context).pushNamed(detailHistoryRoute);
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('lib/assets/images/inbox.png',
                        width: 200, height: 200),
                    const Text('Inbox kosong'),
                  ],
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
