import 'package:flutter/material.dart';
import 'package:onfood/widgets/get_color.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/cloud/constructor/cloud_menus.dart';
import 'package:provider/provider.dart';

class CustomRoundButton extends StatelessWidget {
  final String icon;
  final CloudMenus menu;

  const CustomRoundButton({
    super.key,
    required this.icon,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    String onTapMenuName = '';
    final OrdersProvider providerData = context.watch<OrdersProvider>();
    if (providerData.pressButton == true) {
      providerData.reset();
    }
    int items = providerData.getItems;
    int totalBuy = providerData.getTotal;
    Map userOrder = providerData.getUserOrders;
    int currentValue = 0;
    return IconButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        backgroundColor: (icon == 'add')
            ? WidgetStateProperty.all(Theme.of(context).colorScheme.primary)
            : getColor(userOrder, menu.menuName, items),
      ),
      onPressed: () {
        if (icon == 'add') {
          items++;
          totalBuy += menu.price;
          if (userOrder.containsKey(menu.menuName)) {
            onTapMenuName = menu.menuName;
            currentValue = userOrder[onTapMenuName] + 1;
            userOrder.addAll({menu.menuName: currentValue});
          } else {
            currentValue = 1;
            userOrder.addAll({menu.menuName: currentValue});
            onTapMenuName = menu.menuName;
          }
          providerData.setData(
            items: items,
            total: totalBuy,
            userOrders: userOrder,
          );
        } else {
          if (items != 0) {
            if (userOrder.containsKey(menu.menuName) &
                (userOrder[menu.menuName] != 0)) {
              items--;
              totalBuy -= menu.price;
              onTapMenuName = menu.menuName;
              currentValue = userOrder[onTapMenuName] - 1;
              if (currentValue == 0) {
                userOrder.remove(menu.menuName);
              } else {
                userOrder.addAll({menu.menuName: currentValue});
              }
              providerData.setData(
                items: items,
                total: totalBuy,
                userOrders: userOrder,
              );
            }
          }
        }
      },
      icon: (icon == 'add') ? const Icon(Icons.add) : const Icon(Icons.remove),
    );
  }
}
