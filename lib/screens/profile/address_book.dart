import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'address_book/address_box.dart';
import 'address_book/address_form_screen.dart';
import 'address_book/address_item.dart';

class AddressBookScreen extends StatefulWidget {
  static const String routeName = '/profile/address_book';
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen>
    with Utility, AppBarMixin, TransitionMixin, LoadingMixin {
  late AddressBookStore _addressStore;

  List<Map<String, dynamic>> data = [];
  Map<String, dynamic>? primaryAddress;

  @override
  void initState() {
    RequestHelper requestHelper =
        Provider.of<RequestHelper>(context, listen: false);

    _addressStore = AddressBookStore(
      requestHelper,
    )..getAddressBook();
    super.initState();
  }

  void openForm({
    required String keyName,
    required List<AddressBookData> addresses,
    Map<String, dynamic>? data,
    String type = 'billing',
  }) {
    List<String>? addressKeys = addresses.map((e) => e.name ?? '').toList();

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => AddressFormScreen(
          initAddress: data,
          type: type,
          keyName: keyName,
          addressKeys: addressKeys,
        ),
        transitionsBuilder: slideTransition,
      ),
    ).then((value) {
      if (value == true) {
        _addressStore.getAddress();
      }
    });
  }

  Widget buildPrimaryEmpty(TranslateType translate) {
    return Text(translate('address_book_address_empty'));
  }

  void goAction(String typeAction, AddressBookData data,
      List<AddressBookData> addresses) {
    switch (typeAction) {
      case 'edit':
        String name = data.name ?? '';
        openForm(
          keyName: name,
          data: data.data,
          addresses: addresses,
          type: name.contains('shipping') ? 'shipping' : 'billing',
        );
        break;
      case 'delete':
        _addressStore.deleteAddressBook(data.name!);
        break;
      case 'primary':
        _addressStore.changePrimaryBook(data.name!);
        break;
      default:

      /// no action
    }
  }

  Widget buildAddressList(
      List<AddressBookData> data, List<AddressBookData> addresses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(data.length, (index) {
        return buildItem(data[index], false, addresses);
      }),
    );
  }

  Widget buildItem(
      AddressBookData item, bool primary, List<AddressBookData> addresses) {
    return AddressItem(
      address: item,
      primary: primary,
      actions: !primary ? const ['edit', 'delete', 'primary'] : null,
      onSelectAction: (String type) => goAction(type, item, addresses),
    );
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: translate('address_book_txt'),
      ),
      body: Observer(builder: (_) {
        if (_addressStore.loading) {
          return buildLoading(context, isLoading: true);
        }
        List<AddressBookData> billing =
            _addressStore.addressBook?.billing ?? [];
        List<AddressBookData> shipping =
            _addressStore.addressBook?.shipping ?? [];

        AddressBookData? billingPrimary =
            billing.firstWhereOrNull((value) => value.name == 'billing');
        AddressBookData? shippingPrimary =
            shipping.firstWhereOrNull((value) => value.name == 'shipping');

        List<AddressBookData> billingBook =
            billing.where((value) => value.name != 'billing').toList();
        List<AddressBookData> shippingBook =
            shipping.where((value) => value.name != 'shipping').toList();

        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(layoutPadding, itemPadding,
                    layoutPadding, itemPaddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddressBox(
                      title: translate('address_book_billing'),
                      trailing: InkResponse(
                        onTap: () => openForm(
                          keyName: 'billing',
                          data: billingPrimary?.data,
                          type: 'billing',
                          addresses: billing,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      ),
                      child: billingPrimary != null
                          ? buildItem(billingPrimary, true, billingBook)
                          : buildPrimaryEmpty(translate),
                    ),
                    const SizedBox(height: itemPaddingMedium),
                    AddressBox(
                      title: translate('address_book_shipping'),
                      trailing: InkResponse(
                        onTap: () => openForm(
                          keyName: 'shipping',
                          data: shippingPrimary?.data,
                          type: 'shipping',
                          addresses: shipping,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      ),
                      child: shippingPrimary != null
                          ? buildItem(shippingPrimary, true, shippingBook)
                          : buildPrimaryEmpty(translate),
                    ),
                    if (_addressStore.addressBook?.billingEnable == true) ...[
                      const SizedBox(height: itemPaddingLarge),
                      AddressBox(
                        title: translate('address_book_billing_book'),
                        trailing: InkResponse(
                          onTap: () => openForm(
                            keyName:
                                _addressStore.addressBook?.newBillingName ?? '',
                            type: 'billing',
                            addresses: billing,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 20,
                          ),
                        ),
                        child: buildAddressList(billingBook, billing),
                      ),
                    ],
                    if (_addressStore.addressBook?.shippingEnable == true) ...[
                      const SizedBox(height: itemPaddingLarge),
                      AddressBox(
                        title: translate('address_book_shipping_book'),
                        trailing: InkResponse(
                          onTap: () => openForm(
                            keyName:
                                _addressStore.addressBook?.newShippingName ??
                                    '',
                            type: 'shipping',
                            addresses: shipping,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 20,
                          ),
                        ),
                        child: buildAddressList(shippingBook, shipping),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            if (_addressStore.loadingPrimary || _addressStore.loadingDelete)
              Align(
                alignment: FractionalOffset.center,
                child: buildLoadingOverlay(context),
              ),
          ],
        );
      }),
    );
  }
}
