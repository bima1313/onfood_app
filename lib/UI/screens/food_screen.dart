import 'package:flutter/material.dart';
import 'package:onfood/services/cloud/constructor/cloud_orders.dart';
import 'package:onfood/widgets/buttons/custom_elevated_button.dart';
import 'package:onfood/widgets/custom_gridview.dart';
import 'package:onfood/services/auth/auth_service.dart';
import 'package:onfood/services/cloud/constructor/cloud_coupons.dart';
import 'package:onfood/services/cloud/constructor/cloud_menus.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String get userId => AuthService().currentUser!.id;
  late final FirebaseCloudStorage _menuService;

  @override
  void initState() {
    _menuService = FirebaseCloudStorage();
    super.initState();
  }

  Future<List> getData() async {
    CloudCoupons coupon;
    coupon = await _menuService.getCoupon(
      ownerUserId: userId,
    );
    final Iterable<CloudMenus> menus = await _menuService.allMenu();
    final Iterable<CloudOrders> historyUser = await _menuService.allOrder(
      ownerUserId: userId,
    );
    final isDone = historyUser.where((value) => value.donePayment == true);
    if (isDone.length % 5 == 0) {
      return [coupon, menus];
    } else {
      coupon = const CloudCoupons(
        documentId: '',
        userId: '',
        discount: 0,
      );
      return [coupon, menus];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data as List;
          final coupon = data[0] as CloudCoupons;
          final menuItems = data[1] as Iterable<CloudMenus>;
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    CustomGridView(menus: menuItems, category: 'makanan'),
                    CustomGridView(menus: menuItems, category: 'minuman'),
                    CustomGridView(menus: menuItems, category: 'snack'),
                    const Padding(padding: EdgeInsets.only(bottom: 64.0)),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomElevatedButton(
                    discount: coupon.discount,
                    documentId: coupon.documentId,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
