import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'address_billing.dart';
import 'widgets/fields/loading_field_address.dart';

class AddressShippingScreen extends StatefulWidget {
  static const String routeName = '/profile/address_shipping';

  const AddressShippingScreen({Key? key}) : super(key: key);

  @override
  State<AddressShippingScreen> createState() => _AddressShippingScreenState();
}

class _AddressShippingScreenState extends State<AddressShippingScreen>
    with SnackMixin, AppBarMixin {
  late AuthStore _authStore;
  late SettingStore _settingStore;
  AddressDataStore? _addressDataStore;
  late CustomerStore _customerStore;
  bool? _loading;

  @override
  void initState() {
    _authStore = Provider.of<AuthStore>(context, listen: false);
    _settingStore = Provider.of<SettingStore>(context, listen: false);

    _customerStore = CustomerStore(_settingStore.requestHelper)
      ..getCustomer(userId: _authStore.user!.id).then(
        (value) {
          String country = _customerStore.customer?.shipping != null
              ? get(_customerStore.customer!.shipping, ['country'], '')
              : '';
          _addressDataStore = AddressDataStore(_settingStore.requestHelper)
            ..getAddressData(
              queryParameters: {
                'country': country,
                'lang': _settingStore.locale,
              },
            );
        },
      );
    super.initState();
  }

  postAddress(Map data) async {
    try {
      setState(() {
        _loading = true;
      });
      TranslateType translate = AppLocalizations.of(context)!.translate;

      List<Map<String, dynamic>> meta = [];

      for (String key in data.keys) {
        if (key.contains('wooccm')) {
          meta.add({
            'key': 'shipping_$key',
            'value': data[key],
          });
        }
      }

      await _customerStore.updateCustomer(
        userId: _authStore.user!.id,
        data: {
          'shipping': data,
          'meta_data': meta,
        },
      );
      if (mounted) showSuccess(context, translate('address_shipping_success'));
      setState(() {
        _loading = false;
      });
    } catch (e) {
      showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  Map<String, dynamic> getAddress(Customer? customer) {
    if (customer == null) {
      return {};
    }
    Map<String, dynamic> data = customer.shipping ?? {};
    if (customer.metaData?.isNotEmpty == true) {
      for (var meta in customer.metaData!) {
        String keyElement = get(meta, ['key'], '');
        if (keyElement.contains('shipping_wooccm')) {
          dynamic valueElement = meta['value'];
          String nameData = keyElement.replaceFirst('shipping_', '');
          data[nameData] = valueElement;
        }
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (_) {
        bool loadingCustomer = _customerStore.loading;
        Customer? customer = _customerStore.customer;
        bool loading = (!loadingCustomer &&
                _addressDataStore?.address?.shipping?.isNotEmpty != true) ||
            loadingCustomer;

        return Scaffold(
          appBar:
              baseStyleAppBar(context, title: translate('address_shipping')),
          body: !loading &&
                  _addressDataStore != null &&
                  _addressDataStore?.address?.shippingSelected == 'disabled'
              ? Center(
                  child: Text(translate('address_disable_shipping'),
                      textAlign: TextAlign.center),
                )
              : getAddress(customer).isNotEmpty &&
                      _addressDataStore?.address?.shipping?.isNotEmpty == true
                  ? AddressChild(
                      address: getAddress(customer),
                      addressFields: _addressDataStore?.address?.shipping ?? {},
                      addressDataStore: !loading ? _addressDataStore : null,
                      onSave: postAddress,
                      loading: _loading,
                      locale: _settingStore.locale,
                      countryType: 'shipping',
                    )
                  : const Padding(
                      padding: EdgeInsets.fromLTRB(layoutPadding,
                          itemPaddingMedium, layoutPadding, itemPaddingLarge),
                      child: LoadingFieldAddress(count: 8),
                    ),
        );
      },
    );
  }
}
