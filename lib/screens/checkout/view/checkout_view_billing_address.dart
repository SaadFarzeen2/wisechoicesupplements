import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/profile/widgets/address_field_form3.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cirilla/store/store.dart';
import 'package:provider/provider.dart';

import 'checkout_address_book.dart';

class CheckoutViewBillingAddress extends StatefulWidget {
  final CartStore cartStore;

  const CheckoutViewBillingAddress({
    Key? key,
    required this.cartStore,
  }) : super(key: key);

  @override
  State<CheckoutViewBillingAddress> createState() => _CheckoutViewBillingAddressState();
}

class _CheckoutViewBillingAddressState extends State<CheckoutViewBillingAddress> with Utility {
  final _formBillingKey = GlobalKey<FormState>();
  late SettingStore _settingStore;
  late AuthStore _authStore;
  late AddressDataStore _addressDataStore;
  AddressBookStore? _addressBookStore;
  String _name = 'billing';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);

    WidgetConfig? widgetConfig = _settingStore.data?.screens?['profile']?.widgets?['profilePage']!;
    Map<String, dynamic>? fields = widgetConfig?.fields;

    bool enableAddressBook = get(fields, ['enableAddressBook'], false);

    if (enableAddressBook && _authStore.isLogin) {
      _addressBookStore = AddressBookStore(_settingStore.requestHelper)..getAddressBook();
    }
    Map<String, dynamic> billing = {
      ...?widget.cartStore.cartData?.billingAddress,
      ...widget.cartStore.checkoutStore.billingAddress,
    };
    String country = get(billing, ['country'], '');
    _addressDataStore = AddressDataStore(_settingStore.requestHelper)
      ..getAddressData(queryParameters: {
        'country': country,
        'lang': _settingStore.locale,
      });
  }

  void onChanged(Map<String, dynamic> value, [String? name]) async {
    if (name != null) {
      setState(() {
        _name = name;
      });
    }

    await widget.cartStore.checkoutStore.changeAddress(
      billing: value,
      shipping: widget.cartStore.checkoutStore.shipToDifferentAddress ? null : value,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (_) {
        Map<String, dynamic> billing = {
          ...?widget.cartStore.cartData?.billingAddress,
          ...widget.cartStore.checkoutStore.billingAddress,
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(translate('checkout_billing_detail'), style: theme.textTheme.titleLarge),
            Padding(
              padding: paddingVerticalMedium,
              child: Column(
                children: [
                  if (_addressBookStore != null && _addressBookStore?.addressBook?.billingEnable == true) ...[
                    if (_addressBookStore!.loading != true)
                      CheckoutAddressBook(
                        valueSelected: _name,
                        data: _addressBookStore?.addressBook ?? AddressBook(),
                        onChanged: onChanged,
                      )
                    else
                      const LoadingFieldAddressItem(width: double.infinity),
                    const SizedBox(height: 15),
                  ],
                  _addressDataStore.address?.billing?.isNotEmpty == true
                      ? AddressFieldForm3(
                          key: Key(_name),
                          addressName: _name,
                          formKey: _formBillingKey,
                          data: billing,
                          addressFields: _addressDataStore.address?.billing ?? {},
                          onChanged: onChanged,
                          countries: _addressDataStore.address?.billingCountries ?? [],
                          states: _addressDataStore.address?.billingStates ?? {},
                          onGetAddressData: (String country) {
                            _addressDataStore.getAddressData(queryParameters: {
                              'country': country,
                              'lang': _settingStore.locale,
                            });
                          },
                          formType: FieldFormType.billing,
                        )
                      : const LoadingFieldAddress(count: 10),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
