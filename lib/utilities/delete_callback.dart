import 'package:flutter/material.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:provider/provider.dart';

Future<void> deleteCallback(
  BuildContext context, {
  required String menuName,
  required int item,
}) async {
  final FirebaseCloudStorage orderService = FirebaseCloudStorage();
  final OrdersProvider providerData = context.read<OrdersProvider>();

  final menu = await orderService.specificMenu(menuName: menuName);

  final int totalPayment = providerData.getTotal;
  final int totalItems = providerData.getItems;
  int cachePrice = menu.price * item;
  int newPayment = totalPayment - cachePrice;
  int totalItemsNow = totalItems - item;
  providerData.newTotal(newPayment: newPayment);
  providerData.deleteMenuOrder(
    menuName: menuName,
    items: totalItemsNow,
  );
}
