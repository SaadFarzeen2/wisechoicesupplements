import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'validate_field.dart';

class AddressFieldSelect extends StatefulWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final bool borderFields;
  final Map<String, dynamic> field;

  const AddressFieldSelect({
    Key? key,
    this.value,
    this.borderFields = false,
    required this.onChanged,
    required this.field,
  }) : super(key: key);

  @override
  State<AddressFieldSelect> createState() => _AddressFieldSelectState();
}

class _AddressFieldSelectState extends State<AddressFieldSelect> with Utility {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(_onChanged);
    super.initState();
  }
  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.text = widget.value ?? getValueDefault(widget.field);
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Save data in current state
  ///
  _onChanged() {
    widget.onChanged(_controller.text);
  }

  String getValueDefault(Map<String, dynamic> field) {
    String defaultValue = get(widget.field, ['default'], '');
    List options = get(widget.field, ['options'], []);
    if (options.isNotEmpty) {
      return options.contains(defaultValue) ? defaultValue : options[0];
    }
    return defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String label = get(widget.field, ['label'], '');
    String placeholder = get(widget.field, ['placeholder'], '');
    bool? requiredInput = get(widget.field, ['required'], true);
    List validate = get(widget.field, ['validate'], []);
    List options = get(widget.field, ['options'], []);

    String? labelText = requiredInput! ? '$label *' : label;

    return TextFormField(
      controller: _controller,
      validator: (String? value) =>
          validateField(translate: translate, validate: validate, requiredInput: requiredInput, value: value),
      readOnly: true,
      onTap: options.isNotEmpty
          ? () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return buildViewModal(
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter stateSetter) {
                        return _ModalSelect(
                          options: options,
                          value: _controller.text,
                          onChange: (String? value) {
                            if (value != null && value != _controller.text) {
                              _controller.text = value;
                            }
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  );
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
              );
            }
          : null,
      decoration: widget.borderFields == true
          ? InputDecoration(
              labelText: labelText,
              hintText: placeholder,
              suffixIcon: const Padding(
                padding: EdgeInsetsDirectional.only(end: itemPaddingMedium),
                child: Icon(FeatherIcons.chevronDown, size: 16),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 2,
                minHeight: 2,
              ),
              contentPadding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.border?.borderSide ?? const BorderSide(),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.enabledBorder?.borderSide ?? const BorderSide(),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.focusedBorder?.borderSide ?? const BorderSide(),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.errorBorder?.borderSide ?? const BorderSide(),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.focusedErrorBorder?.borderSide ?? const BorderSide(),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.disabledBorder?.borderSide ?? const BorderSide(),
              ),
              floatingLabelBehavior: options.isNotEmpty ? FloatingLabelBehavior.always : null,
            )
          : InputDecoration(
              labelText: labelText,
              hintText: placeholder,
              suffixIcon: const Icon(FeatherIcons.chevronDown, size: 16),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 2,
                minHeight: 2,
              ),
              floatingLabelBehavior: options.isNotEmpty ? FloatingLabelBehavior.always : null,
            ),
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

class _ModalSelect extends StatelessWidget with Utility {
  final String? value;
  final List options;
  final Function(String? value)? onChange;

  _ModalSelect({
    Key? key,
    this.value,
    this.options = const [],
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: List.generate(options.length, (index) {
        String item = '${options[index]}';
        TextStyle? titleStyle = theme.textTheme.titleSmall;
        TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);
        return CirillaTile(
          title: Text(item, style: item == value ? activeTitleStyle : titleStyle),
          trailing: item == value ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
          isChevron: false,
          onTap: () {
            onChange?.call(item);
          },
        );
      }),
    );
  }
}
