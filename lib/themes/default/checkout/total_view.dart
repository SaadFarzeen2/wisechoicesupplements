import 'package:flutter/material.dart';

enum TotalType {
  container,
  containerPrice,
  containerAll,
  heading,
}

class TotalView extends StatelessWidget {
  final String title;
  final String price;
  final TotalType type;

  const TotalView({
    Key? key,
    required this.title,
    required this.price,
    this.type = TotalType.container,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    TextStyle? titleStyle;
    TextStyle? priceStyle;

    switch (type) {
      case TotalType.containerPrice:
        titleStyle = theme.textTheme.bodyMedium;
        priceStyle = theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color);
        break;
      case TotalType.containerAll:
        titleStyle = theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color);
        priceStyle = theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color);
        break;
      case TotalType.heading:
        titleStyle = theme.textTheme.titleMedium;
        priceStyle = theme.textTheme.titleLarge?.copyWith(color: theme.primaryColor);
        break;
      default:
        titleStyle = theme.textTheme.bodyMedium;
        priceStyle = theme.textTheme.bodyMedium;
        break;
    }
    return Row(
      children: [
        Expanded(child: Text(title, style: titleStyle)),
        Text(price, style: priceStyle),
      ],
    );
  }
}
