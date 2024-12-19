import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onfood/constants/routes.dart';
import 'package:onfood/provider/history_provider.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/constructor/cloud_coupons.dart';
import 'package:onfood/services/cloud/constructor/cloud_orders.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/utilities/casting_date_time.dart';
import 'package:onfood/utilities/sorting_orders.dart';
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
    final CloudCoupons coupon = await _orderService.getCoupon(
      ownerUserId: userId,
    );
    final Iterable<CloudOrders> allOrder = await _orderService.allOrder(
      ownerUserId: userId,
    );

    return [coupon, allOrder];
  }

  @override
  Widget build(BuildContext context) {
    final HistoryProvider providerHistory = context.watch<HistoryProvider>();
    final OrdersProvider providerData = context.watch<OrdersProvider>();
    final NumberFormat currency = NumberFormat("#,##0", 'ID');

    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data as List;
            final coupon = data[0] as CloudCoupons;
            final userOrders = data[1] as Iterable<CloudOrders>;

            if (userOrders.isNotEmpty) {
              return ListView.builder(
                itemCount: userOrders.length,
                itemBuilder: (context, index) {
                  final CloudOrders order = userOrders.elementAt(index);
                  final Map<String, dynamic> sortedOrders = sortingOrders(
                    orders: order.userOrders,
                  );
                  final dateTime = order.dateTime.toDate();
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sortedOrders.keys.first,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          castToID(dateTime: dateTime),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'lihat selengkapnya',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
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
                        userOrder: sortedOrders,
                        tableNumber: order.tableNumber,
                        total: order.totalPayment,
                        donePayment: order.donePayment,
                        information: order.information,
                      );
                      providerHistory.ordersLength(length: userOrders.length);
                      providerData.usingCoupon(
                        discount: coupon.discount,
                        couponId: coupon.documentId,
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
