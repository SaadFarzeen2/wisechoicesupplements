import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

import 'validate_field.dart';

class AddressFieldNumber extends StatefulWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final bool borderFields;
  final Map<String, dynamic> field;

  const AddressFieldNumber({
    Key? key,
    this.value,
    this.borderFields = false,
    required this.onChanged,
    required this.field,
  }) : super(key: key);

  @override
  State<AddressFieldNumber> createState() => _AddressFieldNumber();
}

class _AddressFieldNumber extends State<AddressFieldNumber> with Utility {
  final _txtInputText = TextEditingController();
  int? _number;

  @override
  void initState() {
    String value = getValueNumber(widget.field, widget.value);
    _txtInputText.text = value;
    _number = int.tryParse(value);

    _txtInputText.addListener(() {
      setState(() {
        _number = _txtInputText.text.isNotEmpty ? ConvertData.stringToInt(_txtInputText.text) : null;
      });
      if (_txtInputText.text != widget.value) {
        widget.onChanged(_txtInputText.text);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _txtInputText.dispose();
    super.dispose();
  }

  String getValueNumber(Map<String, dynamic> fields, String? value) {
    String defaultValue = get(widget.field, ['default'], '');
    if (value?.isEmpty == true) {
      return '';
    }
    if (int.tryParse(value ?? '') != null) {
      return value ?? '';
    }
    return int.tryParse(defaultValue) != null ? defaultValue : '';
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String label = get(widget.field, ['label'], '');
    String placeholder = get(widget.field, ['placeholder'], '');
    bool? requiredInput = get(widget.field, ['required'], true);

    String max = get(widget.field, ['max'], '');
    String min = get(widget.field, ['min'], '');

    String? labelText = requiredInput! ? '$label *' : label;

    int? valueMax = max.isNotEmpty ? ConvertData.stringToInt(max) : null;
    int? valueMin = min.isNotEmpty ? ConvertData.stringToInt(min) : null;

    int? number = _number;

    Widget suffix = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Ink(
          decoration: ShapeDecoration(
            color: theme.primaryColor,
            shape: const CircleBorder(),
          ),
          child: IconButton(
            onPressed: () {
              if (number == null || valueMax == null || number < valueMax) {
                if (number != null) {
                  if (valueMin != null && number + 1 < valueMin) {
                    _txtInputText.text = '$valueMin';
                  } else {
                    _txtInputText.text = '${number + 1}';
                  }
                } else {
                  if (valueMin != null) {
                    _txtInputText.text = '$valueMin';
                  } else {
                    _txtInputText.text = '1';
                  }
                }
              }
            },
            icon: const Icon(FontAwesomeIcons.plus, size: 12),
            color: theme.colorScheme.onPrimary,
            constraints: const BoxConstraints(maxWidth: 30),
          ),
        )
      ],
    );

    Widget prefix = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Ink(
          decoration: ShapeDecoration(
            color: theme.primaryColor,
            shape: const CircleBorder(),
          ),
          child: IconButton(
            onPressed: () {
              if (number == null || valueMin == null || valueMin < number) {
                if (number != null) {
                  if (valueMax != null && number - 1 > valueMax) {
                    _txtInputText.text = '$valueMax';
                  } else {
                    _txtInputText.text = '${number - 1}';
                  }
                } else {
                  if (valueMin != null) {
                    _txtInputText.text = '$valueMin';
                  } else {
                    _txtInputText.text = '1';
                  }
                }
              }
            },
            icon: const Icon(FontAwesomeIcons.minus, size: 12),
            color: theme.colorScheme.onPrimary,
            constraints: const BoxConstraints(maxWidth: 30),
          ),
        )
      ],
    );

    return TextFormField(
      controller: _txtInputText,
      validator: (String? value) => validateFieldNumber(
        translate: translate,
        requiredInput: requiredInput,
        value: value,
        min: valueMin,
        max: valueMax,
      ),
      decoration: widget.borderFields == true
          ? InputDecoration(
              labelText: labelText,
              hintText: placeholder,
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
              suffixIcon: suffix,
              prefixIcon: prefix,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            )
          : InputDecoration(
              labelText: labelText,
              hintText: placeholder,
              suffixIcon: suffix,
              prefixIcon: prefix,
            ),
      keyboardType: TextInputType.number,
    );
  }
}
