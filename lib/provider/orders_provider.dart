import 'package:flutter/material.dart';

class OrdersProvider extends ChangeNotifier {
  int _items = 0;
  int _total = 0;
  int _discount = 0;
  String _couponId = '';
  bool _pressingButton = false;
  final Map _userOrders = {};

  void setData({
    required int items,
    required int total,
    required Map userOrders,
  }) {
    _items = items;
    _total = total;
    _userOrders.addAll(userOrders);

    notifyListeners();
  }

  void usingCoupon({required int discount, required String couponId}) {
    _discount = discount;
    _couponId = couponId;
    notifyListeners();
  }

  void reset() {
    _items = 0;
    _total = 0;
    _userOrders.clear();
    _discount = 0;
    _couponId = '';
    _pressingButton = false;
  }

  void pressingButton({required bool pressButton}) {
    _pressingButton = pressButton;

    notifyListeners();
  }

  int get getItems => _items;
  int get getTotal => _total;
  int get getDiscount => _discount;
  String get getCoupounId => _couponId;
  Map get getUserOrders => _userOrders;
  bool get pressButton => _pressingButton;
}
