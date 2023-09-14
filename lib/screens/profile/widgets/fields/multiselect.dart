import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class AddressFieldMultiSelect extends StatefulWidget {
  final List? value;
  final ValueChanged<List> onChanged;
  final Map<String, dynamic> field;

  const AddressFieldMultiSelect({
    Key? key,
    this.value,
    required this.onChanged,
    required this.field,
  }) : super(key: key);

  @override
  State<AddressFieldMultiSelect> createState() => _AddressFieldMultiSelectState();
}

class _AddressFieldMultiSelectState extends State<AddressFieldMultiSelect> with Utility {
  List getValueDefault(Map<String, dynamic> field, List options) {
    List data = [];
    dynamic defaultValue = get(widget.field, ['default'], []);
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

  Widget buildListData({required List data, required ThemeData theme}) {
    return Wrap(
      spacing: itemPaddingSmall,
      runSpacing: itemPaddingSmall,
      children: List.generate(data.length, (index) {
        String item = '${data[index]}';

        return SizedBox(
          height: 34,
          child: ElevatedButton(
            onPressed: () {
              List value = [...data];
              value.removeAt(index);
              widget.onChanged(value);
            },
            style: ElevatedButton.styleFrom(textStyle: theme.textTheme.bodySmall),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item),
                const SizedBox(width: itemPadding),
                const Icon(FeatherIcons.xCircle, size: 12),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String label = get(widget.field, ['label'], '');
    bool? requiredInput = get(widget.field, ['required'], true);
    List options = get(widget.field, ['options'], []);

    List defaultValue = getValueDefault(widget.field, options);
    List value = getValue(widget.value, options, defaultValue);

    String? labelText = requiredInput! ? '$label *' : label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: theme.inputDecorationTheme.labelStyle),
        const SizedBox(height: 8),
        Container(
          padding: paddingVerticalTiny.add(paddingHorizontalSmall),
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: const BoxConstraints(minHeight: 50),
          child: Row(
            children: [
              Expanded(
                child: buildListData(data: value, theme: theme),
              ),
              const SizedBox(width: itemPaddingMedium),
              InkResponse(
                onTap: options.isNotEmpty
                    ? () async {
                        List? data = await showModalBottomSheet<List?>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return buildViewModal(
                              child: _ModalSelect(
                                options: options,
                                value: [...value],
                                onChange: (List? dataChanged) {
                                  Navigator.pop(context, dataChanged);
                                },
                              ),
                            );
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          ),
                        );
                        if (data != null && data != value) {
                          widget.onChanged(data);
                        }
                      }
                    : null,
                child: const Icon(FeatherIcons.chevronRight, size: 16),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildViewModal({Widget? child}) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      double height = constraints.maxHeight;
      return Container(
        constraints: BoxConstraints(maxHeight: height - 100),
        padding: paddingHorizontal.add(paddingVerticalLarge),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      );
    });
  }
}

class _ModalSelect extends StatefulWidget {
  final List? value;
  final List options;
  final Function(List? value)? onChange;

  const _ModalSelect({
    Key? key,
    this.value,
    this.options = const [],
    this.onChange,
  }) : super(key: key);

  @override
  State<_ModalSelect> createState() => _ModalSelectState();
}

class _ModalSelectState extends State<_ModalSelect> {
  late List _value;

  @override
  void initState() {
    _value = widget.value ?? [];
    super.initState();
  }

  void changeValue(String item) {
    setState(() {
      if (_value.contains(item)) {
        _value.remove(item);
      } else {
        _value.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: List.generate(widget.options.length, (index) {
              String item = '${widget.options[index]}';
              TextStyle? titleStyle = theme.textTheme.titleSmall;
              TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);

              bool isSelected = _value.contains(item);

              return CirillaTile(
                title: Text(item, style: isSelected ? activeTitleStyle : titleStyle),
                leading: CirillaRadio.iconCheck(isSelect: isSelected),
                isChevron: false,
                onTap: () => changeValue(item),
              );
            }),
          ),
        ),
        const SizedBox(height: itemPaddingLarge),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => widget.onChange?.call(_value),
            child: Text(AppLocalizations.of(context)!.translate('edit_account_save')),
          ),
        )
      ],
    );
  }
}
