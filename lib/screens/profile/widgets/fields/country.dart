import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/country_address.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'modal_country_address.dart';
import 'validate_field.dart';

String _getName(String code, List<CountryAddressData> data) {
  CountryAddressData? country = data.firstWhereOrNull((element) => element.code == code);
  return country?.name?.isNotEmpty == true ? country!.name! : code;
}

String? _getCode(String? name, List<CountryAddressData> data) {
  CountryAddressData? country = data.firstWhereOrNull((element) => element.name == name);
  return country?.code;
}

class AddressFieldCountry extends StatefulWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final List<CountryAddressData> countries;
  final Map<String, dynamic> field;
  final bool borderFields;

  const AddressFieldCountry({
    Key? key,
    this.value,
    required this.onChanged,
    required this.countries,
    required this.field,
    this.borderFields = false,
  }) : super(key: key);

  @override
  State<AddressFieldCountry> createState() => _AddressFieldCountryState();
}

class _AddressFieldCountryState extends State<AddressFieldCountry> with Utility {
  final _controller = TextEditingController();

  @override
  void initState() {
    String defaultValue = get(widget.field, ['default'], '');
    _controller.text = _getName(widget.value ?? defaultValue, widget.countries);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AddressFieldCountry oldWidget) {
    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.value != widget.value && widget.value != _controller.text) {
        String defaultValue = get(widget.field, ['default'], '');
        String? country = widget.countries.firstWhereOrNull((element) => element.code == widget.value)?.name;
        _controller.text = country ?? defaultValue;
      }
    });
    super.didUpdateWidget(oldWidget);
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      controller: _controller,
      validator: (String? value) => validateField(
        translate: translate,
        validate: validate,
        requiredInput: requiredInput,
        value: value,
      ),
      readOnly: true,
      onTap: () async {
        String? code = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return buildViewModal(
              context,
              child: ModalCountryAddress(
                data: widget.countries,
                value: _getCode(_controller.text, widget.countries),
                onChange: (String? countryValue) => Navigator.pop(context, countryValue),
                title: translate('address_select_country'),
                titleSearch: translate('address_search'),
              ),
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
        );
        if (code != null && code != widget.value) {
          _controller.text = _getName(code, widget.countries);
          widget.onChanged(code);
        }
      },
      decoration: widget.borderFields
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
            )
          : InputDecoration(
              labelText: labelText,
              hintText: placeholder,
              suffixIcon: const Icon(FeatherIcons.chevronDown, size: 16),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 2,
                minHeight: 2,
              ),
            ),
    );
  }

  Widget buildViewModal(BuildContext context, {Widget? child}) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height - mediaQuery.viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: height - 100),
      padding: paddingHorizontal.add(paddingVerticalLarge),
      margin: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: SizedBox(
        width: double.infinity,
        child: child,
      ),
    );
  }
}
