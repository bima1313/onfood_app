import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef OnPressedCallback = void Function(BuildContext context);
const bool _autoClose = true;
const Color _backgroundColor = Colors.white;
const Color _iconColor = Colors.white;

class CustomSlidingAction extends StatelessWidget {
  /// Creates a [CustomSlidingAction].
  ///
  /// The [icon] argument must be not null.

  const CustomSlidingAction({
    super.key,
    this.autoClose = _autoClose,
    this.backgroundColor = _backgroundColor,
    this.borderRadius = BorderRadius.zero,
    required this.icon,
    this.iconColor = _iconColor,
    this.iconSize = 24.0,
    this.label,
    this.labelColor,
    this.labelSize = 16.0,
    required this.onPressed,
    this.spacing = 4.0,
  });

  /// Whether the enclosing [Slidable] will be closed after [onPressed]
  /// occurred.
  ///
  /// Defaults to [true].
  final bool autoClose;

  /// The background color of this action.
  ///
  /// Defaults to [Colors.white].
  final Color backgroundColor;

  /// The borderRadius of this action.
  ///
  /// Defaults to [BorderRadius.zero].
  final BorderRadius borderRadius;

  /// An icon to display above the [label].
  final IconData icon;

  /// The icon color of this action.
  ///
  /// Defaults to [Colors.white].
  final Color iconColor;

  /// the icon size of this action.
  ///
  /// defaults to 32.0.
  final double iconSize;

  /// A label to display below the [icon].
  final String? label;

  /// The label color of this action.
  final Color? labelColor;

  /// the icon size of this action.
  ///
  /// defaults to 16.0.
  final double labelSize;

  /// Called when the action is tapped or otherwise activated.
  ///
  /// If this callback is null, then the action will be disabled.
  final OnPressedCallback? onPressed;

  /// The space between [icon] and [label] if both set.
  ///
  /// Defaults to 4.0.
  final double spacing;

  void _pressCallback(BuildContext context) {
    onPressed?.call(context);
    if (autoClose) {
      Slidable.of(context)?.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    children.add(
      Icon(icon),
    );

    if (label != null) {
      children.add(SizedBox(height: spacing));
      children.add(
        Text(
          label!,
          style: TextStyle(
            color: (labelColor == null) ? iconColor : labelColor,
            fontSize: labelSize,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Expanded(
      child: SizedBox.expand(
        child: OutlinedButton(
          onPressed: () => (onPressed != null) ? _pressCallback(context) : null,
          style: OutlinedButton.styleFrom(
            iconSize: iconSize,
            iconColor: iconColor,
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
          ),
          child: (children.length == 1)
              ? children.first
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...children.map(
                      (child) => Flexible(child: child),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
