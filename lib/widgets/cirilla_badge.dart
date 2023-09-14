import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:flutter/material.dart';

enum CirillaBadgeType { primary, error, success }

class CirillaBadge extends StatelessWidget {
  final String label;
  final double size;
  final EdgeInsetsGeometry? padding;
  final CirillaBadgeType? type;

  const CirillaBadge({
    Key? key,
    required this.label,
    this.size = 19,
    this.padding,
    this.type,
  }) : super(key: key);

  Color getColor(ThemeData theme) {
    switch (type) {
      case CirillaBadgeType.error:
        return theme.colorScheme.error;
      case CirillaBadgeType.success:
        return ColorBlock.green;
      case CirillaBadgeType.primary:
        return theme.primaryColor;
      default:
        return Colors.black.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    EdgeInsetsGeometry defaultPadding = padding ?? paddingHorizontalTiny.add(secondPaddingVerticalTiny);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: size,
          constraints: BoxConstraints(minWidth: size),
          alignment: Alignment.center,
          padding: label.length > 1 ? defaultPadding : null,
          decoration: BoxDecoration(color: getColor(theme), borderRadius: BorderRadius.circular(size / 2)),
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 0.2),
          ),
        )
      ],
    );
  }
}
