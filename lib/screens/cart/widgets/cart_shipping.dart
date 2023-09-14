import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/extension/strings.dart';
import 'package:cirilla/models/address/country.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

import 'cart_change_address.dart';

class CartShipping extends StatefulWidget {
  final CartData? cartData;
  final CartStore? cartStore;
  final bool changeAddress;

  const CartShipping({
    Key? key,
    this.cartData,
    this.cartStore,
    this.changeAddress = true,
  }) : super(key: key);

  @override
  State<CartShipping> createState() => _CartShippingState();
}

class _CartShippingState extends State<CartShipping> with LoadingMixin, SnackMixin {
  CountryStore? _countryStore;
  bool loadingShipping = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RequestHelper requestHelper = Provider.of<RequestHelper>(context);
    _countryStore = CountryStore(requestHelper)..getCountry();
  }

  Future<void> _selectShipping(BuildContext context, int? packageId, String? rateId) async {
    try {
      loadingShipping = false;
      await widget.cartStore!.selectShipping(packageId: packageId, rateId: rateId);
    } catch (e) {
      loadingShipping = false;
      showError(context, e);
    }
  }

  void showModal(BuildContext context, int index) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadiusBottomSheet,
      ),
      builder: (BuildContext context) {
        return CartChangeAddress(index: index);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    int lengthShip = widget.cartData?.shippingRate?.length ?? 0;
    if (lengthShip == 0) {
      return Container();
    }
    return Observer(
      builder: (_) {
        return Column(
          children: List.generate(lengthShip, (index) {
            TranslateType translate = AppLocalizations.of(context)!.translate;

            ShippingRate shippingRate = widget.cartData!.shippingRate!.elementAt(index);

            List<String?> shippingAddress = [];

            String? city = get(shippingRate.destination, ['city'], '');
            String? countryId = get(shippingRate.destination, ['country'], '');
            String? postcode = get(shippingRate.destination, ['postcode'], '');
            String? stateId = get(shippingRate.destination, ['state'], '');

            List data = shippingRate.shipItem!;

            String nameShipping = get(shippingRate.name, [], '');

            CountryData? countrySelect =
                _countryStore?.country.firstWhereOrNull((element) => element.code == countryId);

            String? country = countrySelect is CountryData ? countrySelect.name : '';

            List<Map<String, dynamic>>? states = countrySelect is CountryData ? countrySelect.states : null;
            Map<String, dynamic>? stateSelect =
                states?.firstWhereOrNull((element) => get(element, ['code'], '') == stateId);
            String? state = get(stateSelect, ['name'], stateId);

            if (postcode != '') shippingAddress.add(postcode);
            if (city != '') shippingAddress.add(city);
            if (state != '') shippingAddress.add(state);
            if (country != '') shippingAddress.add(country);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.changeAddress && index == 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(shippingAddress.join(', '), style: textTheme.bodySmall),
                      ),
                      GestureDetector(
                        onTap: () => showModal(context, index),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(FeatherIcons.mapPin, size: 14, color: theme.primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              translate('address_change'),
                              style: textTheme.bodySmall?.copyWith(color: theme.primaryColor),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                if (index == 0) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: itemPadding),
                    child: Divider(height: 2, thickness: 1),
                  ),
                  Text(translate('cart_shipping_method'), style: textTheme.titleMedium),
                ],
                if (data.isNotEmpty) ...[
                  const SizedBox(height: itemPadding),
                  Text(nameShipping),
                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        ShipItem dataShipInfo = data.elementAt(index);

                        String name = dataShipInfo.name!;

                        bool selected = dataShipInfo.selected!;

                        bool isloadingShipping = loadingShipping ? loadingShipping : selected;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ButtonSelect.icon(
                              color: theme.focusColor,
                              colorSelect: theme.primaryColor,
                              isSelect: isloadingShipping,
                              onTap: !selected
                                  ? () => _selectShipping(context, shippingRate.packageId, dataShipInfo.rateId)
                                  : null,
                              child: Text(
                                StringParse(name).unescape,
                                style: isloadingShipping
                                    ? textTheme.titleSmall?.copyWith(color: theme.primaryColor)
                                    : textTheme.titleSmall,
                              ),
                            ),
                            Padding(padding: EdgeInsetsDirectional.only(start: selected ? 1 : itemPaddingMedium))
                          ],
                        );
                      },
                    ),
                  ),
                ]
              ],
            );
          }),
        );
      },
    );
  }
}
