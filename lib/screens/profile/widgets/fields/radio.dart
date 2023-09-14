import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AddressFieldRadio extends StatelessWidget with Utility {
  final String? value;
  final ValueChanged<String> onChanged;
  final bool borderFields;
  final Map<String, dynamic> field;

  const AddressFieldRadio({
    Key? key,
    this.value,
    this.borderFields = false,
    required this.onChanged,
    required this.field,
  }) : super(key: key);

  Widget buildContainer({required List<Widget> children, required ThemeData theme}) {
    if (borderFields) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(itemPadding),
          border: Border.all(color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ?? theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  String? getValue({required List options, String defaultValue = '', String? data}) {
    if (data != null && options.contains(data)) {
      return data;
    }
    if (options.isNotEmpty) {
      return options.contains(defaultValue) ? defaultValue : null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String label = get(field, ['label'], '');
    bool? requiredInput = get(field, ['required'], true);
    List options = get(field, ['options'], []);
    String defaultValue = get(field, ['default'], '');

    String? labelText = requiredInput! ? '$label *' : label;
    String? dataSelect = getValue(options: options, defaultValue: defaultValue, data: value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: theme.inputDecorationTheme.labelStyle),
        if (borderFields) const SizedBox(height: itemPadding),
        buildContainer(
          theme: theme,
          children: List.generate(options.length, (index) {
            String item = '${options[index]}';
            bool isSelect = item == dataSelect;
            Color? textColor = isSelect ? theme.textTheme.titleMedium?.color : null;

            return CirillaTile(
              leading: CirillaRadio(isSelect: isSelect),
              title: Text(item, style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
              isChevron: false,
              isDivider: !(borderFields && index == options.length - 1),
              padding: borderFields ? paddingHorizontalMedium : null,
              onTap: () {
                if (item != dataSelect) {
                  onChanged(item);
                }
              },
            );
          }),
        ),
      ],
    );
  }
}
