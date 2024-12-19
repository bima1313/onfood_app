import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:onfood/provider/orders_provider.dart';
import 'package:onfood/utilities/delete_callback.dart';
import 'package:onfood/widgets/custom_list_tile.dart';
import 'package:onfood/widgets/custom_sliding_action.dart';
import 'package:provider/provider.dart';

class SlidableList extends StatelessWidget {
  /// Creates a [SlidableList].
  ///
  /// The [networkImage], [menuName] and [items] arguments must be not null.

  const SlidableList({
    super.key,
    required this.networkImage,
    required this.menuName,
    required this.items,
  });

  /// An image to display on the left.
  final String networkImage;

  /// An menu name to display beetween the [networkImage] and [items]
  final String menuName;

  /// An items to display on the right.
  final int items;

  @override
  Widget build(BuildContext context) {
    final OrdersProvider providerData = context.watch<OrdersProvider>();
    if (providerData.getUserOrders.length == 1) {
      return CustomListTile(
        networkImage: networkImage,
        width: 100,
        height: 100,
        borderRadius: const BorderRadius.all(
          Radius.circular(16.0),
        ),
        menuName: menuName,
        items: items,
        textStyle: const TextStyle(fontSize: 16),
      );
    } else {
      return Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            CustomSlidingAction(
              backgroundColor: Colors.red,
              label: 'Delete',
              icon: Icons.delete,
              onPressed: (context) => deleteCallback(
                context,
                menuName: menuName,
                item: items,
              ),
            ),
          ],
        ),
        child: CustomListTile(
          networkImage: networkImage,
          width: 100,
          height: 100,
          borderRadius: const BorderRadius.all(
            Radius.circular(16.0),
          ),
          menuName: menuName,
          items: items,
          textStyle: const TextStyle(fontSize: 16),
        ),
      );
    }
  }
}
