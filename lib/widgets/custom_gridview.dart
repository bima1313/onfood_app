import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onfood/widgets/buttons/custom_round_button.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/services/cloud/constructor/cloud_menus.dart';
import 'package:provider/provider.dart';

class CustomGridView extends StatelessWidget {
  /// Creates a [CustomGridView].
  ///
  /// The [menus] and [category] arguments must be not null.
  const CustomGridView({
    super.key,
    required this.menus,
    required this.category,
  });

  /// The menus to display of grid view.
  final Iterable<CloudMenus> menus;

  /// The category menus of grid view.
  final String category;

  @override
  Widget build(BuildContext context) {
    final OrdersProvider providerData = context.watch<OrdersProvider>();
    final Map<String, dynamic> userOrder = providerData.getUserOrders;
    final NumberFormat currency = NumberFormat("#,##0", 'ID');
    final Iterable<CloudMenus> menuCategory = menus.where(
      (element) => element.category == category,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: menuCategory.length,
          itemBuilder: (context, index) {
            final menu = menuCategory.elementAt(index);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        image: NetworkImage(menu.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    menu.menuName,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    'Rp.${currency.format(menu.price)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomRoundButton(icon: Icons.remove, menu: menu),
                    (userOrder[menu.menuName] == null)
                        ? const Text('0')
                        : Text(userOrder[menu.menuName].toString()),
                    CustomRoundButton(icon: Icons.add, menu: menu),
                  ],
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
