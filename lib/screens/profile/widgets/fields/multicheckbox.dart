import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AddressFieldMultiCheckbox extends StatelessWidget with Utility {
  final List? value;
  final ValueChanged<List> onChanged;
  final Map<String, dynamic> field;
  final bool borderFields;

  const AddressFieldMultiCheckbox({
    Key? key,
    this.value,
    required this.onChanged,
    required this.field,
    this.borderFields = false,
  }) : super(key: key);

  List getValueDefault(Map<String, dynamic> field, List options) {
    List data = [];
    dynamic defaultValue = get(field, ['default'], []);
    if (defaultValue is List) {
      for (var value in defaultValue) {
        if (options.contains(value)) {
          data.add(value);
        }
      }
    }
    return data;
  }

  List getValue(List? value, List options, List defaultValue) {
    if (value is List) {
      List data = [];
      for (var item in value) {
        if (options.contains(item)) {
          data.add(item);
        }
      }
      return data;
    }
    return defaultValue;
  }

  Widget buildItem({
    required item,
    bool isSelected = false,
    required ThemeData theme,
    required GestureTapCallback selectItem,
  }) {
    return Row(
      children: [
        CirillaRadio.iconCheck(
          isSelect: isSelected,
          onChange: (_) => selectItem(),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(item, style: theme.inputDecorationTheme.labelStyle),
        )
      ],
    );
  }

  Widget buildContainer({required Widget child, required ThemeData theme}) {
    if (borderFields) {
      return Container(
        width: double.infinity,
        padding: paddingMedium,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ?? theme.dividerColor),
        ),
        child: child,
      );
    }
    return SizedBox(
      width: double.infinity,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String label = get(field, ['label'], '');

    bool? requiredInput = get(field, ['required'], true);
    List options = get(field, ['options'], []);

    List defaultValue = getValueDefault(field, options);
    List valueItem = getValue(value, options, defaultValue);

    String? labelText = requiredInput! ? '$label *' : label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: theme.inputDecorationTheme.labelStyle),
        const SizedBox(height: itemPaddingSmall),
        buildContainer(
          theme: theme,
          child: Wrap(
            runSpacing: itemPaddingSmall,
            children: List.generate(
              options.length,
              (index) {
                String item = '${options[index]}';
                bool isSelected = valueItem.contains(item);

                return buildItem(
                  item: item,
                  isSelected: isSelected,
                  theme: theme,
                  selectItem: () {
                    List data = [...valueItem];

                    if (isSelected) {
                      data.remove(item);
                    } else {
                      data.add(item);
                    }
                    onChanged(data);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
