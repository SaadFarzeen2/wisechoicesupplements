import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AddressFieldCheckbox extends StatelessWidget with Utility {
  final String? value;
  final ValueChanged<String> onChanged;
  final Map<String, dynamic> field;

  const AddressFieldCheckbox({
    Key? key,
    this.value,
    required this.onChanged,
    required this.field,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String label = get(field, ['label'], '');
    String defaultValue = get(field, ['default'], '0');

    String valueData = value ?? defaultValue;

    return Row(
      children: [
        CirillaRadio.iconCheck(
          isSelect: valueData == '1',
          onChange: (check) {
            onChanged(check ? '1' : '0');
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(label, style: theme.inputDecorationTheme.labelStyle),
        )
      ],
    );
  }
}
