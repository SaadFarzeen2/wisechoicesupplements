import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

import 'validate_field.dart';

class AddressFieldPassword extends StatefulWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final bool borderFields;
  final Map<String, dynamic> field;

  const AddressFieldPassword({
    Key? key,
    this.value,
    this.borderFields = false,
    required this.onChanged,
    required this.field,
  }) : super(key: key);

  @override
  State<AddressFieldPassword> createState() => _AddressFieldPassword();
}

class _AddressFieldPassword extends State<AddressFieldPassword> with Utility {
  bool _obscureText = true;
  final _txtInputText = TextEditingController();
  final _focusNode = FocusNode();
  String _value = '';

  @override
  void initState() {
    _txtInputText.addListener(_onChanged);
    _focusNode.addListener(_onBlur);
    String defaultValue = get(widget.field, ['default'], '');
    _txtInputText.text = widget.value ?? defaultValue;
    super.initState();
  }

  @override
  void dispose() {
    _txtInputText.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
    if (_focusNode.hasFocus == false) {
      _focusNode.unfocus();
      _focusNode.canRequestFocus = false;
    }
  }

  /// Handle update value when user leave input or they are done editing the text in the field
  ///
  _onBlur() {
    if (!_focusNode.hasFocus) {
      widget.onChanged(_value);
    }
  }

  /// Save data in current state
  ///
  _onChanged() {
    setState(() {
      _value = _txtInputText.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    String label = get(widget.field, ['label'], '');
    String placeholder = get(widget.field, ['placeholder'], '');
    bool? requiredInput = get(widget.field, ['required'], true);
    List validate = get(widget.field, ['validate'], []);
    String? labelText = requiredInput! ? '$label *' : label;

    return TextFormField(
      controller: _txtInputText,
      focusNode: _focusNode,
      validator: (String? value) =>
          validateField(translate: translate, validate: validate, requiredInput: requiredInput, value: value),
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
              suffixIcon: IconButton(
                iconSize: 16,
                icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: _updateObscure,
              ),
            )
          : InputDecoration(
              labelText: labelText,
              hintText: placeholder,
              suffixIcon: IconButton(
                iconSize: 16,
                icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: _updateObscure,
              ),
            ),
      obscureText: _obscureText,
    );
  }
}
