import 'package:flutter/material.dart';
import 'package:onfood/widgets/custom_elevated_button.dart';
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
    final coupons = await _menuService.allCoupon();
    final menus = await _menuService.allMenu();

    return [coupons, menus];
  }

  @override
  Widget build(BuildContext context) {
    int discount;
    String documentId;
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data as List;
          final getCoupon = data[0] as Iterable<CloudCoupons>;
          final menuItems = data[1] as Iterable<CloudMenus>;
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
                child: CustomElevatedButton(
                  discount: discount,
                  documentId: documentId,
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
