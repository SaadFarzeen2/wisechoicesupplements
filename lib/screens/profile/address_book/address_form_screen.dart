import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../address_billing.dart';

class AddressFormScreen extends StatefulWidget {
  final Map<String, dynamic>? initAddress;
  final String keyName;
  final String type;
  final List<String> addressKeys;

  const AddressFormScreen({
    Key? key,
    required this.keyName,
    this.initAddress,
    this.type = 'billing',
    this.addressKeys = const [],
  }) : super(key: key);

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen>
    with SnackMixin, AppBarMixin {
  late AuthStore _authStore;
  late SettingStore _settingStore;
  AddressDataStore? _addressDataStore;
  late CustomerStore _customerStore;
  bool? _loading;

  late bool edit;

  @override
  void initState() {
    _authStore = Provider.of<AuthStore>(context, listen: false);
    _settingStore = Provider.of<SettingStore>(context, listen: false);

    _customerStore = CustomerStore(_settingStore.requestHelper);

    String country = get(widget.initAddress, ['country'], '');
    _addressDataStore = AddressDataStore(_settingStore.requestHelper)
      ..getAddressData(queryParameters: {
        'country': country,
        'lang': _settingStore.locale,
      });
    edit = widget.initAddress != null;
    super.initState();
  }

  postAddress(Map data) async {
    try {
      setState(() {
        _loading = true;
      });
      TranslateType translate = AppLocalizations.of(context)!.translate;
      Map? billing;
      Map? shipping;
      List<Map<String, dynamic>> meta = [];

      switch (widget.keyName) {
        case 'shipping':
          shipping = data;
          for (String key in data.keys) {
            if (key == 'address_nickname' || key.contains('wooccm')) {
              meta.add({
                'key': '${widget.keyName}_$key',
                'value': data[key],
              });
            }
          }
          break;
        case 'billing':
          billing = data;
          for (String key in data.keys) {
            if (key == 'address_nickname' || key.contains('wooccm')) {
              meta.add({
                'key': '${widget.keyName}_$key',
                'value': data[key],
              });
            }
          }
          break;
        default:
          for (String key in data.keys) {
            meta.add({
              'key': '${widget.keyName}_$key',
              'value': data[key],
            });
          }
      }
      if (!edit) {
        String keyBook = widget.type == 'shipping'
            ? 'wc_address_book_shipping'
            : 'wc_address_book_billing';
        meta.add({
          'key': keyBook,
          'value': [...widget.addressKeys, widget.keyName],
        });
      }

      Map<String, dynamic> dataCustom = {
        'billing': billing,
        'shipping': shipping,
        'meta_data': meta,
      }..removeWhere((key, value) => value == null);

      await _customerStore.updateCustomer(
        userId: _authStore.user!.id,
        data: dataCustom,
      );
      setState(() {
        _loading = false;
      });
      if (mounted) {
        String textSuccess = edit
            ? translate('address_book_update_success_form')
            : translate('address_book_add_success_form');
        showSuccess(context, textSuccess);
        Navigator.pop(context, true);
      }
    } catch (e) {
      showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Map<String, dynamic> fieldNickName = {
      "label": translate('address_book_input_nickname'),
      "placeholder": translate('address_book_hint_nickname'),
      "class": ["form-row-wide"],
      "autocomplete": "organization",
      "priority": 1,
      "required": false
    };

    return Observer(
      builder: (_) {
        AddressData? addressData = _addressDataStore?.address;
        bool loading = addressData?.billing?.isNotEmpty != true;

        Map<String, dynamic> addressFields = widget.type == 'shipping'
            ? {
                'shipping_address_nickname': fieldNickName,
                ...addressData?.shipping ?? {}
              }
            : {
                'billing_address_nickname': fieldNickName,
                ...addressData?.billing ?? {}
              };
        return Scaffold(
          appBar: baseStyleAppBar(
            context,
            title: edit
                ? translate('address_book_edit_form_txt')
                : translate('address_book_add_form_txt'),
          ),
          body: addressFields.isNotEmpty &&
                  (addressData?.billing?.isNotEmpty == true ||
                      addressData?.shipping?.isNotEmpty == true)
              ? AddressChild(
                  address: widget.initAddress,
                  addressFields: addressFields,
                  addressDataStore: !loading ? _addressDataStore : null,
                  onSave: postAddress,
                  loading: _loading,
                  locale: _settingStore.locale,
                  countryType: widget.type,
                )
              : const Padding(
                  padding: EdgeInsets.fromLTRB(layoutPadding, itemPaddingMedium,
                      layoutPadding, itemPaddingLarge),
                  child: LoadingFieldAddress(count: 10),
                ),
        );
      },
    );
  }
}
