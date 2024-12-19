import 'package:flutter/material.dart';
import 'package:onfood/utilities/sorting_orders.dart';

class OrdersProvider extends ChangeNotifier {
  bool _pressingButton = false;
  int _discount = 0;
  bool _inUsed = false;
  int _items = 0;
  int _total = 0;
  String _couponId = '';
  Map<String, int> _userOrders = {};
  final Map<String, String> _menuImages = {};

  void changeItems({
    required String menuName,
    required int items,
    required int menuItem,
  }) {
    _userOrders.update(
      menuName,
      (value) => menuItem,
    );
    _items += items;

    notifyListeners();
  }

  void changeTotal({required int newTotal}) {
    _total += newTotal;

    notifyListeners();
  }

  void coupon({required bool inUsed}) {
    _inUsed = inUsed;

    notifyListeners();
  }

  void deleteMenuOrder({required String menuName, int items = 0}) {
    _userOrders.remove(menuName);
    if (items != 0) {
      _items = items;
    }

    notifyListeners();
  }

  void newTotal({required int newPayment}) {
    _total = newPayment;

    notifyListeners();
  }

  void pressingButton({required bool pressButton}) {
    _pressingButton = pressButton;

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

  void usingCoupon({required int discount, required String couponId}) {
    _discount = discount;
    _couponId = couponId;
    notifyListeners();
  }

  void setData({
    required int items,
    required int total,
    required Map<String, int> userOrders,
    required Map<String, String> menuImages,
  }) {
    _items = items;
    _total = total;

    _userOrders.addAll(userOrders);
    _menuImages.addAll(menuImages);

    _userOrders = sortingOrders(orders: _userOrders).cast();

    notifyListeners();
  }

  bool get pressButton => _pressingButton;
  int get getDiscount => _discount;
  bool get couponInUsed => _inUsed;
  int get getItems => _items;
  int get getTotal => _total;
  Map<String, String> get getMenuImages => _menuImages;
  Map<String, int> get getUserOrders => _userOrders;
  String get getCoupounId => _couponId;
}
