import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/constructor/cloud_coupons.dart';
import 'package:onfood/services/cloud/constructor/cloud_orders.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:onfood/utilities/fuzzy/reward_systems.dart';

final FirebaseCloudStorage _orderService = FirebaseCloudStorage();
String get userId => AuthService().currentUser!.id;
String get displayName => AuthService().currentUser!.displayName;

/// Creating a order for saving into Database
Future<CloudOrders> createOrder({
  required String tableNumber,
  required Map<String, dynamic> order,
  required int totalPayment,
  required String information,
}) async {
  final Timestamp dateTime = Timestamp.now();
  final coupon = await _orderService.getCoupon(ownerUserId: userId);
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

  if (coupon.discount != 0) {
    await _orderService.changeDocumentId(
      ownerUserId: userId,
      discount: coupon.discount,
      newDocumentId: newOrder.documentId,
      oldDocumentId: coupon.documentId,
    );
  }

  return newOrder;
}

Future<int> checkReward() async {
  final historyUser = await _orderService.allOrder(ownerUserId: userId);
  final Iterable<CloudOrders> isDone =
      historyUser.where((done) => done.donePayment == true);
  int totalUserPayment = 0;
  if (historyUser.length % 5 == 0 &&
      (historyUser.length - isDone.length) == 1) {
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
