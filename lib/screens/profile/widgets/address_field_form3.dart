import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/country_address.dart';
import 'package:cirilla/screens/checkout/view/delivery_location_icon.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/checkout_store.dart';
import 'package:cirilla/store/data/address_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fields/fields.dart';

enum FieldFormType {
  billing,
  shipping,
  other,
}

class AddressFieldForm3 extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? data;
  final Map<String, dynamic> addressFields;
  final Function(Map<String, dynamic>) onChanged;
  final Function(String) onGetAddressData;
  final Widget? titleModal;
  final List<CountryAddressData> countries;
  final Map<String, List<CountryAddressData>> states;
  final bool borderFields;
  final String addressName;
  final FieldFormType formType;

  const AddressFieldForm3({
    Key? key,
    this.formKey,
    this.titleModal,
    this.borderFields = false,
    required this.addressFields,
    required this.data,
    required this.onChanged,
    required this.onGetAddressData,
    this.countries = const [],
    this.states = const {},
    required this.addressName,
    this.formType = FieldFormType.other,
  }) : super(key: key);

  Map<String, dynamic> getFields(Map<String, dynamic> fields) {
    Map<String, dynamic> data = {};

    for (String key in fields.keys) {
      dynamic value = fields[key];
      bool disabled = get(value, ['disabled'], false);
      if (!disabled) {
        data.addAll({
          key: value,
        });
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context);
    AddressDataStore addressDataStore = AddressDataStore(settingStore.requestHelper);
    Map<String, dynamic> fields = getFields(addressFields);
    if (fields.isEmpty) {
      return Container();
    }

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double widthView =
            constraints.maxWidth != double.infinity ? constraints.maxWidth : MediaQuery.of(context).size.width;
        List<String> keys = fields.keys.toList();
        return Form(
          key: formKey,
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 0,
              runSpacing: itemPaddingMedium,
              children: [
                if (titleModal != null)
                  Container(
                    width: widthView,
                    padding: const EdgeInsets.only(bottom: itemPaddingExtraLarge),
                    child: Center(
                      child: titleModal,
                    ),
                  ),
                ...List.generate(
                  keys.length,
                  (index) {
                    String key = keys.toList()[index];
                    Map<String, dynamic> field = fields[key];
                    String type = get(field, ['type'], 'text');
                    String position = get(field, ['position'], 'form-row-wide');

                    String defaultName = key.split('_').length > 1 ? key.split('_').sublist(1).join('_') : key;
                    String name = get(field, ['name'], defaultName);

                    late Widget child;
                    String keyInput = '${addressName}_$name';
                    switch (type) {
                      case 'text':
                        child = AddressFieldText(
                          key: Key(keyInput),
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                          // <Handle for pick location button at checkout page>
                          suffixIcon: (field['autocomplete'] == 'address-line1' && formType != FieldFormType.other)
                              ? DeliveryLocationIcon(
                                  callback: (place, {String? address2}) async {
                                    CheckoutStore checkoutStore =
                                        Provider.of<AuthStore>(context, listen: false).cartStore.checkoutStore;
                                    switch (formType) {
                                      case FieldFormType.billing:
                                        await checkoutStore.updateBillingFromMap(
                                          place: place,
                                          addressDataStore: addressDataStore,
                                          locale: settingStore.locale,
                                          address2: address2,
                                        );
                                        break;
                                      case FieldFormType.shipping:
                                        await checkoutStore.updateShippingFromMap(
                                          place: place,
                                          addressDataStore: addressDataStore,
                                          locale: settingStore.locale,
                                          address2: address2,
                                        );
                                        break;
                                      default:
                                        break;
                                    }
                                  },
                                )
                              : null,
                          // </Handle for pick location button at checkout page>
                        );
                        break;
                      case 'heading':
                        child = AddressFieldHeading(field: field);
                        break;
                      case 'email':
                        child = AddressFieldEmail(
                          key: Key(keyInput),
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                        );
                        break;
                      case 'tel':
                        child = AddressFieldPhone(
                          key: Key(keyInput),
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                        );
                        break;
                      case 'textarea':
                        child = AddressFieldTextArea(
                          key: Key(keyInput),
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                        );
                        break;
                      case 'password':
                        child = AddressFieldPassword(
                          key: Key(keyInput),
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                        );
                        break;
                      case 'select':
                        child = AddressFieldSelect(
                          key: Key(keyInput),
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                        );
                        break;
                      case 'radio':
                        child = AddressFieldRadio(
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                        );
                        break;
                      case 'checkbox':
                        child = AddressFieldCheckbox(
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                        );
                        break;
                      case 'time':
                        child = AddressFieldTime(
                          key: Key(keyInput),
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                        );
                        break;
                      case 'date':
                        child = AddressFieldDate(
                          key: Key(keyInput),
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                        );
                        break;
                      case 'number':
                        child = AddressFieldNumber(
                          key: Key(keyInput),
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                        );
                        break;
                      case 'country':
                        child = AddressFieldCountry(
                          key: Key(keyInput),
                          value: data?[name],
                          countries: countries,
                          field: field,
                          onChanged: (String value) {
                            Map<String, dynamic> stateData = {};
                            for (var fieldKey in fields.keys) {
                              dynamic fieldData = fields[fieldKey];
                              if (fieldData is Map &&
                                  get(fieldData, ['type'], '') == 'state' &&
                                  get(fieldData, ['country_field'], '') == key) {
                                String defaultNameState = fieldKey.split('_').length > 1
                                    ? fieldKey.split('_').sublist(1).join('_')
                                    : fieldKey;
                                String nameState = get(fieldData, ['name'], defaultNameState);
                                List<CountryAddressData>? stateList = states[value];
                                stateData.addAll({
                                  nameState: stateList?.isNotEmpty == true ? stateList![0].code : '',
                                });
                              }
                            }
                            onChanged({...?data, ...stateData, name: value});
                            onGetAddressData(value);
                          },
                          borderFields: borderFields,
                        );
                        break;
                      case 'state':
                        String countryField = get(field, ['country_field'], '');
                        Map<String, dynamic>? fieldCountry = fields[countryField];
                        String defaultNameCountry = countryField.split('_').length > 1
                            ? countryField.split('_').sublist(1).join('_')
                            : countryField;
                        String? nameCountry = get(fieldCountry, ['name'], defaultNameCountry);
                        String? valueCountry = nameCountry != null ? get(data, [nameCountry]) : null;
                        List<CountryAddressData>? stateData = states[valueCountry];

                        child = AddressFieldState(
                          key: Key('${keyInput}_${defaultNameCountry}_$valueCountry'),
                          value: data?[name],
                          states: stateData ?? [],
                          field: field,
                          onChanged: (String value) {
                            onChanged({
                              ...?data,
                              name: value,
                            });
                          },
                          borderFields: borderFields,
                        );
                        break;
                      case 'multiselect':
                        child = AddressFieldMultiSelect(
                          value: data?[name],
                          onChanged: (List value) => onChanged({...?data, name: value}),
                          field: field,
                        );
                        break;
                      case 'multicheckbox':
                        child = AddressFieldMultiCheckbox(
                          value: data?[name],
                          onChanged: (List value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                        );
                        break;
                      case 'colorpicker':
                        child = AddressFieldColorPicker(
                          key: Key(keyInput),
                          value: data?[name],
                          onChanged: (String value) => onChanged({...?data, name: value}),
                          field: field,
                          borderFields: borderFields,
                        );
                        break;
                      default:
                        child = Container();
                    }
                    if (position == 'form-row-wide') {
                      return SizedBox(
                        width: widthView,
                        child: child,
                      );
                    }

                    if (position == 'form-row-last') {
                      String? preKey = index > 0 ? keys[index - 1] : null;
                      Map<String, dynamic>? preField = preKey != null ? fields[preKey] : null;
                      String prePosition = get(preField, ['position'], 'form-row-wide');
                      if (prePosition != 'form-row-first') {
                        return Container(
                          width: widthView,
                          alignment: AlignmentDirectional.topEnd,
                          child: SizedBox(
                            width: (widthView - itemPaddingMedium) / 2,
                            child: child,
                          ),
                        );
                      }
                    }

                    if (position == 'form-row-first') {
                      String? nextKey = index < keys.length - 1 ? keys[index + 1] : null;
                      Map<String, dynamic>? nextField = nextKey != null ? fields[nextKey] : null;
                      String nextPosition = get(nextField, ['position'], 'form-row-wide');
                      if (nextPosition != 'form-row-last') {
                        return Container(
                          width: widthView,
                          alignment: AlignmentDirectional.topStart,
                          child: SizedBox(
                            width: (widthView - itemPaddingMedium) / 2,
                            child: child,
                          ),
                        );
                      }
                    }
                    return SizedBox(
                      width: (widthView - itemPaddingMedium) / 2,
                      child: child,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
