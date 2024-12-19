import 'package:flutter/material.dart';
import 'package:onfood/utilities/get_color.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/cloud/constructor/cloud_menus.dart';
import 'package:provider/provider.dart';

class CustomRoundButton extends StatelessWidget {
  /// Creates a [CustomRoundButton].
  ///
  /// The [icon] and [menu] arguments must be not null.
  const CustomRoundButton({
    super.key,
    required this.icon,
    required this.menu,
  });

  /// Create an icon
  final IconData icon;

  /// To create a button of menu.
  final CloudMenus menu;

  @override
  Widget build(BuildContext context) {
    final OrdersProvider providerData = context.watch<OrdersProvider>();
    if (providerData.pressButton == true) {
      providerData.reset();
    }
    int items = providerData.getItems;
    int totalBuy = providerData.getTotal;
    Map<String, int> userOrder = providerData.getUserOrders;
    Map<String, String> menuImage = providerData.getMenuImages;
    int currentValue = 0;
    String onTapMenuName = '';

    return IconButton(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        backgroundColor: (icon == Icons.add)
            ? Theme.of(context).colorScheme.primary
            : getColor(getMap: userOrder, key: menu.menuName, values: items),
      ),
      onPressed: () {
        if (providerData.pressButton == false) {
          if (icon == Icons.add) {
            items++;
            totalBuy += menu.price;

            if (userOrder.containsKey(menu.menuName)) {
              onTapMenuName = menu.menuName;
              currentValue = userOrder[onTapMenuName]! + 1;
              userOrder.addAll({menu.menuName: currentValue});
            } else {
              currentValue = 1;
              userOrder.addAll({menu.menuName: currentValue});
              menuImage.addAll({menu.menuName: menu.imageUrl});
              onTapMenuName = menu.menuName;
            }
            providerData.setData(
              items: items,
              total: totalBuy,
              userOrders: userOrder,
              menuImages: menuImage,
            );
          } else {
            if (items != 0) {
              if (userOrder.containsKey(menu.menuName) &
                  (userOrder[menu.menuName] != 0)) {
                items--;
                totalBuy -= menu.price;
                onTapMenuName = menu.menuName;
                currentValue = userOrder[onTapMenuName]! - 1;
                if (currentValue == 0) {
                  userOrder.remove(menu.menuName);
                  menuImage.remove(menu.menuName);
                } else {
                  userOrder.addAll({menu.menuName: currentValue});
                }
                providerData.setData(
                  items: items,
                  total: totalBuy,
                  userOrders: userOrder,
                  menuImages: menuImage,
                );
              }
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
