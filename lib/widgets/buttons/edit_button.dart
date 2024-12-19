import 'package:flutter/material.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/cloud/firebase_cloud_storage.dart';
import 'package:provider/provider.dart';

class EditButton extends StatelessWidget {
  /// Creates a [EditButton].
  ///
  /// The [menuName], [icon] and [item] arguments must be not null.
  const EditButton({
    super.key,
    required this.menuName,
    required this.icon,
    required this.item,
  });

  /// For adding or removing the item from [menuName]
  final String menuName;

  /// Create an icon
  final IconData icon;

  /// For adding or removing the item from [menuName]
  final int item;

  @override
  Widget build(BuildContext context) {
    final FirebaseCloudStorage orderService = FirebaseCloudStorage();
    final OrdersProvider providerData = context.watch<OrdersProvider>();
    int menuItem = item;
    int items = 0;
    int totalBuy = 0;

    return IconButton(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () async {
        final menu = await orderService.specificMenu(menuName: menuName);

        if (icon == Icons.add) {
          items++;
          menuItem++;
          totalBuy += menu.price;
          providerData.changeItems(
            menuName: menuName,
            items: items,
            menuItem: menuItem,
          );
          providerData.changeTotal(newTotal: totalBuy);
        } else {
          if (menuItem != 0) {
            items--;
            menuItem--;
            totalBuy -= menu.price;
            providerData.changeItems(
              menuName: menuName,
              items: items,
              menuItem: menuItem,
            );
            providerData.changeTotal(newTotal: totalBuy);

            if (menuItem == 0) {
              providerData.deleteMenuOrder(menuName: menuName);
            }
          }
        }
      },
      icon: (icon == Icons.add)
          ? const Icon(Icons.add)
          : const Icon(Icons.remove),
    );
  }
}
