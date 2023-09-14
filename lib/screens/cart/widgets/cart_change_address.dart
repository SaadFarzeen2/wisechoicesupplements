import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/profile/address_billing.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';

List<String> _showFields = ['country', 'state', 'postcode', 'city'];

class CartChangeAddress extends StatefulWidget {
  final int? index;
  const CartChangeAddress({Key? key, this.index}) : super(key: key);

  @override
  State<CartChangeAddress> createState() => _CartChangeAddressState();
}

class _CartChangeAddressState extends State<CartChangeAddress> with SnackMixin, AppBarMixin {
  late SettingStore _settingStore;
  late AddressDataStore _addressDataStore;
  CartStore? _cartStore;

  @override
  void initState() {
    _settingStore = Provider.of<SettingStore>(context, listen: false);
    _cartStore = Provider.of<AuthStore>(context, listen: false).cartStore;

    Map? destination = _cartStore?.cartData?.shippingRate?.elementAt(widget.index!).destination;
    String country = get(destination, ['country'], '');
    _addressDataStore = AddressDataStore(_settingStore.requestHelper)
      ..getAddressData(
        queryParameters: {
          'country': country,
          'lang': _settingStore.locale,
        },
      );
    super.initState();
  }

  postAddressCart(Map data) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    try {
      await _cartStore!.updateCustomerCart(data: {'shipping_address': data, 'billing_address': data});
      if (mounted) showSuccess(context, translate('address_shipping_success'));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      showError(context, e);
    }
  }

  Map<String, dynamic> getFields(Map<String, dynamic> data) {
    Map<String, dynamic> result = {};

    for (String key in data.keys) {
      String defaultName = key.split('_').length > 1 ? key.split('_').sublist(1).join('_') : key;
      String name = get(data, [key, 'name'], defaultName);
      if (_showFields.contains(name)) {
        result[key] = data[key];
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Map? destination = _cartStore?.cartData?.shippingRate?.elementAt(widget.index!).destination;

      TranslateType translate = AppLocalizations.of(context)!.translate;

      return SizedBox(
        height: MediaQuery.of(context).size.height - 140,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: getFields(_addressDataStore.address?.shipping ?? {}).isNotEmpty
              ? AddressChild(
                  address: destination as Map<String, dynamic>?,
                  addressFields: getFields(_addressDataStore.address?.shipping ?? {}),
                  addressDataStore: _addressDataStore,
                  onSave: postAddressCart,
                  titleModal: Text(
                    translate('address_change'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  note: false,
                  borderFields: true,
                  locale: _settingStore.locale,
                  countryType: 'shipping',
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(
                    layoutPadding,
                    itemPaddingMedium,
                    layoutPadding,
                    itemPaddingLarge,
                  ),
                  child: LoadingFieldAddress(count: _showFields.length),
                ),
        ),
      );
    });
  }
}
