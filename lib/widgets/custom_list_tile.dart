import 'package:flutter/material.dart';
import 'package:onfood/widgets/buttons/edit_button.dart';

class CustomListTile extends StatelessWidget {
  /// Creates a [CustomListTile].
  ///
  /// The [networkImage], [menuName] and [items] arguments must be not null.

  const CustomListTile({
    super.key,
    required this.networkImage,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    required this.menuName,
    required this.items,
    this.spacing = 16.0,
    this.textStyle,
  });

  /// An image to display on the left.
  final String networkImage;

  /// Increase the size of width on image
  final double width;

  /// Increase the size of height on image
  final double height;

  /// The borderRadius of image.
  ///
  /// Defaults to [BorderRadius.zero].
  final BorderRadius borderRadius;

  /// An menu name to display beetween the [networkImage] and [items]
  final String menuName;

  /// An items to display on the right.
  final int items;

  /// The space between images.
  ///
  /// Defaults to 16.0.
  final double spacing;

  /// Adding the style of the text
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: spacing),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: NetworkImage(networkImage),
              fit: BoxFit.fill,
            ),
          ),
          width: width,
          height: height,
          child: null,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: 8.0,
              bottom: spacing,
            ),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      menuName,
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  spacing: 8.0,
                  children: [
                    EditButton(
                      icon: Icons.remove,
                      menuName: menuName,
                      item: items,
                    ),
                    Text(
                      items.toString(),
                      style: textStyle,
                    ),
                    EditButton(
                      icon: Icons.add,
                      menuName: menuName,
                      item: items,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
