import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'countries.dart' as list_countries;
import 'phone_number.dart';

const String defaultCountryCode = 'US';

enum CirillaPhoneInputType { enable, disable, error }

class CirillaPhoneInput extends StatefulWidget {
  final String? initialValue;
  final TextInputType keyboardType;
  final bool autoValidate;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool autofocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final ValueChanged<PhoneNumber>? onChanged;
  final FormFieldSetter<PhoneNumber>? onSaved;
  final void Function(PhoneNumber)? onSubmitted;
  final String? searchText;

  const CirillaPhoneInput({
    Key? key,
    this.initialValue,
    this.keyboardType = TextInputType.phone,
    this.autoValidate = true,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    this.searchText,
  }) : super(key: key);

  @override
  State<CirillaPhoneInput> createState() => _CirillaPhoneInputState();
}

class _CirillaPhoneInputState extends State<CirillaPhoneInput> with Utility {
  final GlobalKey _keyContainer = GlobalKey();
  double widthContainer = 80;

  late SettingStore _settingStore;
  Map<String, String>? _selectedCountry;
  List<Map<String, String>?> filteredCountries = [];
  List<Map<String, String>?> countries = [];
  FormFieldValidator<String>? validator;
  FocusNode? _focusNode;

  CirillaPhoneInputType type = CirillaPhoneInputType.enable;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    WidgetConfig widgetConfig = _settingStore.data!.settings!['general']!.widgets!['general']!;

    List includeCountry = get(widgetConfig.fields, ['includeCountry'], []);

    List excludeCountry = get(widgetConfig.fields, ['excludeCountry'], []);

    String initCodeCountry = get(widgetConfig.fields, ['initCodeCountry'], defaultCountryCode);

    List<Map<String, String>?> dataExclude = _getExclude(list_countries.countries, excludeCountry);

    List<Map<String, String>?> dataInclude =
        _getInclude(dataExclude, list_countries.countries, includeCountry, initCodeCountry);

    String initialCountryCode = _getInit(dataInclude, initCodeCountry);

    Map<String, String>? init =
        dataInclude.firstWhere((item) => item!['code'] == initialCountryCode, orElse: () => null);

    Map<String, String>? selectedCountry = dataInclude
        .firstWhere((item) => item!['code']!.toUpperCase() == initialCountryCode.toUpperCase(), orElse: () => init);

    setState(() {
      countries = dataInclude;
      _selectedCountry = selectedCountry;
      validator =
          widget.autoValidate ? ((value) => value!.length != 10 ? 'Invalid Mobile Number' : null) : widget.validator;
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_getSizes);

    if (!widget.enabled) {
      type = CirillaPhoneInputType.disable;
    }
    _focusNode = widget.focusNode is FocusNode ? widget.focusNode : FocusNode();
    super.initState();
  }

  _getSizes(_) {
    final RenderBox renderBoxContainer = _keyContainer.currentContext!.findRenderObject() as RenderBox;
    final size = renderBoxContainer.size;
    setState(() {
      widthContainer = size.width + 16;
    });
  }

  Color colorLine(ThemeData theme) {
    if (_focusNode!.hasFocus && (type != CirillaPhoneInputType.error && type != CirillaPhoneInputType.disable)) {
      return theme.primaryColor;
    }
    switch (type) {
      case CirillaPhoneInputType.disable:
        return theme.disabledColor.withOpacity(0.2);
      case CirillaPhoneInputType.error:
        return theme.colorScheme.error;
      default:
        return theme.dividerColor;
    }
  }

  void onFieldSubmitted(String value) {
    CirillaPhoneInputType newType = !widget.enabled
        ? CirillaPhoneInputType.disable
        : type == CirillaPhoneInputType.error
            ? CirillaPhoneInputType.error
            : CirillaPhoneInputType.enable;
    setState(() {
      type = newType;
    });
    if (widget.onSubmitted != null) {
      PhoneNumber data = PhoneNumber(
        countryISOCode: _selectedCountry!['code'],
        countryCode: _selectedCountry!['dial_code'],
        number: value,
      );
      widget.onSubmitted!(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color colorBorderCountry = colorLine(theme);
    double widthLine = _focusNode!.hasFocus ? 2 : 1;
    return Stack(
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: _selectedCountry?['dial_code'] ?? '+',
            prefixIcon: Container(
              width: widthContainer,
            ),
            border: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
          ),
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          controller: widget.controller,
          focusNode: _focusNode,
          textAlignVertical: TextAlignVertical.center,
          onTap: () {
            // FocusScope.of(context).requestFocus(_focusNode);
          },
          validator: (String? value) {
            String? resultValidator = validator!(value);
            setState(() {
              type = resultValidator != null ? CirillaPhoneInputType.error : CirillaPhoneInputType.enable;
            });
            return resultValidator;
          },
          onFieldSubmitted: onFieldSubmitted,
          onSaved: (value) {
            if (widget.onSaved != null) {
              widget.onSaved!(
                PhoneNumber(
                  countryISOCode: _selectedCountry!['code'],
                  countryCode: _selectedCountry!['dial_code'],
                  number: value,
                ),
              );
            }
          },
          onChanged: (value) {
            if (value.startsWith("+") && value.length > 2 && value.length < 5) {
              setState(() {
                _selectedCountry = countries.firstWhere((item) => item!['dial_code']!.startsWith(value),
                    orElse: () => _selectedCountry);
              });
            }

            if (widget.onChanged != null) {
              widget.onChanged!(
                PhoneNumber(
                  countryISOCode: _selectedCountry!['code'],
                  countryCode: _selectedCountry!['dial_code'],
                  number: value,
                ),
              );
            }
          },
          textInputAction: widget.textInputAction,
        ),
        PositionedDirectional(
          top: 0,
          start: 0,
          child: InkWell(
            onTap: () => _changeCountry(),
            child: Container(
              key: _keyContainer,
              height: 48,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: itemPaddingMedium, right: itemPadding),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  end: BorderSide(width: widthLine, color: colorBorderCountry),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedCountry!['flag']!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  const Icon(FeatherIcons.chevronDown, size: 16)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _changeCountry() async {
    filteredCountries = countries;

    Map<String, String>? result = await showDialog<Map<String, String>?>(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        ThemeData theme = Theme.of(context);
        TranslateType translate = AppLocalizations.of(context)!.translate;

        InputBorder border = OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: theme.dividerColor),
          borderRadius: BorderRadius.circular(24),
        );
        return StatefulBuilder(
          builder: (ctx, setState) => Dialog(
            child: Container(
              padding: paddingDefault,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: widget.searchText ?? translate('label_search_phone'),
                      border: border,
                      enabledBorder: border,
                      focusedErrorBorder: border,
                      focusedBorder: border,
                      errorBorder: border,
                      disabledBorder: border,
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredCountries = countries
                            .where((country) => country!['name']!.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCountries.length,
                      itemBuilder: (ctx, index) => Column(
                        children: <Widget>[
                          ListTile(
                            leading: Text(
                              filteredCountries[index]!['flag']!,
                              style: const TextStyle(fontSize: 30),
                            ),
                            title: Text(
                              filteredCountries[index]!['name']!,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Text(
                              filteredCountries[index]!['dial_code']!,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              Navigator.of(context).pop(filteredCountries[index]);
                            },
                          ),
                          const Divider(thickness: 1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (result != null && !(result == _selectedCountry)) {
      setState(() {
        _selectedCountry = result;
      });
    }
  }
}

List<Map<String, String>?> _getInclude(
  List<Map<String, String>?> dataExclude,
  List<Map<String, String>?> allCountries,
  List include,
  String initCodeCountry,
) {
  List dataInit = [initCodeCountry];

  if (include.isNotEmpty) {
    List<Map<String, String>?> initCountries =
        allCountries.where((element) => dataInit.contains(element!['code'])).toList();

    List<Map<String, String>?> newIncludes =
        dataExclude.where((element) => include.contains(element!['code'])).toList();

    if (newIncludes.contains(initCountries.elementAt(0))) {
      return newIncludes;
    } else {
      newIncludes.add(initCountries.first);
      return newIncludes;
    }
  }
  return dataExclude;
}

List<Map<String, String>?> _getExclude(
  List<Map<String, String>?> allCountries,
  List exclude,
) {
  if (exclude.isNotEmpty) {
    return allCountries.where((element) => !exclude.contains(element!['code'])).toList();
  }
  return allCountries;
}

String _getInit(List<Map<String, String>?> allCountries, String value) {
  if (value.isEmpty || allCountries.isEmpty) {
    return defaultCountryCode;
  }
  // bool checkExist = allCountries.firstWhere((element) => element!['code'] == value) != null;
  bool checkExist = allCountries.indexWhere((element) => element!['code'] == value) > -1;
  if (checkExist) {
    return value;
  }
  return allCountries[0]!['code']!;
}
