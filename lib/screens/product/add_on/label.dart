import 'package:cirilla/constants/color_block.dart';
import 'package:flutter/material.dart';

class LabelField extends StatelessWidget {
  final String label;
  final String type;
  final String? price;
  final String? textDuration;
  final bool require;

  const LabelField({
    Key? key,
    required this.label,
    this.type = 'label',
    this.require = false,
    this.price,
    this.textDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    TextStyle? style = theme.textTheme.titleMedium;
    TextStyle? durationStyle = theme.textTheme.bodyMedium?.copyWith(color: style?.color);

    if (type == 'heading') {
      style = theme.textTheme.titleLarge;
      durationStyle = theme.textTheme.titleSmall?.copyWith(color: style?.color);
    }

    return Text.rich(
      TextSpan(
        text: label,
        children: [
          if (require)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: ColorBlock.red, fontWeight: FontWeight.w600),
            ),
          if (price?.isNotEmpty == true) TextSpan(text: ' (+$price)'),
          if (textDuration?.isNotEmpty == true) TextSpan(text: ' $textDuration', style: durationStyle),
        ],
      ),
      style: style,
    );
  }
}

class DescriptionField extends StatelessWidget {
  final String description;

  const DescriptionField({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Text(description, style: theme.textTheme.bodySmall);
  }
}
