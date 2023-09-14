import 'package:cirilla/constants/styles.dart';
import 'package:flutter/material.dart';

class AddressBox extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;

  const AddressBox({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title, style: theme.textTheme.titleMedium),
            ),
            if (trailing != null) ...[
              const SizedBox(width: itemPaddingMedium),
              trailing!,
            ],
          ],
        ),
        const SizedBox(height: itemPadding),
        child,
      ],
    );
  }
}
