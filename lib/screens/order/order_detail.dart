import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/order/widgets/order_billing.dart';
import 'package:cirilla/screens/order/widgets/order_item.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/models/order/order.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/types/types.dart';
import 'package:ui/notification/notification_screen.dart';

import '../screens.dart';
import 'widgets/order_node.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = '/order_detail';
  final Map? args;

  const OrderDetailScreen({Key? key, this.args}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with Utility, LoadingMixin, AppBarMixin, NavigationMixin, OrderMixin, SnackMixin {
  late AuthStore _authStore;
  RequestHelper? _requestHelper;
  OrderData? _orderData;
  bool _loading = true;

  @override
  void didChangeDependencies() async {
    _authStore = Provider.of<AuthStore>(context);
    _requestHelper = Provider.of<RequestHelper>(context);

    if (widget.args != null && widget.args?['orderDetail'] != null) {
      setState(() {
        _loading = false;
      });
      _orderData = widget.args!['orderDetail'];
    } else if (widget.args?['id'] != null) {
      int id = ConvertData.stringToInt(widget.args!['id']);
      await getOrderDetail(id);
    }
    super.didChangeDependencies();
  }

  Future<void> getOrderDetail(int? id) async {
    try {
      OrderData data = await _requestHelper!.getOrderDetail(orderId: id);
      _orderData = data;
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    TranslateType translate = AppLocalizations.of(context)!.translate;

    TextTheme textTheme = theme.textTheme;

    TextStyle? itemStyle = textTheme.bodySmall;

    if (_loading) {
      return Scaffold(
        body: Center(child: buildLoading(context, isLoading: _loading)),
      );
    }
    if (_orderData == null) {
      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate('order')),
        body: NotificationScreen(
          title: Text(
            translate('order'),
            style: textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          content: Text(
            translate('order_no_data'),
            style: textTheme.bodyMedium,
          ),
          iconData: FeatherIcons.box,
        ),
      );
    }

    Color? textColor = textTheme.titleMedium?.color;

    Map? billingData = _orderData!.billing;

    Map? shippingData = _orderData!.shipping;

    String? currencySymbol = get(_orderData!.currencySymbol, [], '');

    String? currency = get(_orderData!.currency, [], '');

    int titleAppBar = get(_orderData!.id, [], 0);

    List<LineItems>? lineItems = _orderData!.lineItems;

    List<ShippingLines>? shippingLines = _orderData!.shippingLines;

    Decoration decoration = BoxDecoration(
      border: Border.all(color: theme.dividerColor),
      borderRadius: BorderRadius.circular(8),
    );

    String price(String? price) {
      return formatCurrency(
        context,
        currency: currency,
        price: price,
        symbol: currencySymbol,
      );
    }

    return Observer(
      builder: (_) {
        return Scaffold(
          appBar: baseStyleAppBar(context, title: translate('order_title', {'id': '# $titleAppBar'})),
          body: ListView(
            padding: const EdgeInsetsDirectional.only(start: 20, end: 20, top: 20),
            children: [
              Container(
                decoration: decoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildItem(
                      padding: const EdgeInsetsDirectional.only(
                          start: itemPaddingMedium, end: itemPaddingMedium, top: itemPaddingMedium),
                      title: translate('order_number'),
                      subTitle: '${_orderData!.id}',
                      status: buildStatus(theme, translate, _orderData!),
                    ),
                    buildItem(
                      padding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
                      title: translate('order_date'),
                      subTitle: formatDate(date: _orderData!.dateCreated!, locate: getLocate(context)),
                    ),
                    buildItem(
                        padding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
                        title: translate('order_email'),
                        subTitle: _authStore.user!.userEmail!),
                    buildItem(
                        padding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
                        title: translate('order_total'),
                        subTitle: price(_orderData!.total)),
                    buildItem(
                        padding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
                        title: translate('order_payment_method'),
                        subTitle: _orderData!.paymentMethodTitle ?? ''),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: itemPaddingMedium, end: itemPaddingMedium, bottom: itemPaddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(translate('order_shipping_method'), style: itemStyle),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (shippingLines != null) ...[
                                Flexible(
                                    child: Text(shippingLines.map((e) => e.methodTitle).join(' , '),
                                        style: textTheme.titleSmall)),
                              ],
                              Text(price(_orderData!.shippingTotal), style: textTheme.titleSmall)
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              OrderNoteWidget(
                padding: const EdgeInsets.only(top: layoutPadding * 2),
                orderId: _orderData!.id!,
                color: textColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: layoutPadding * 2, bottom: itemPaddingLarge),
                child: Text(
                  translate('order_information'),
                  style: textTheme.titleMedium,
                ),
              ),
              if (lineItems != null) ...[
                ...List.generate(lineItems.length, (index) {
                  LineItems productData = lineItems.elementAt(index);
                  int? id = productData.productId;
                  return OrderItem(
                    productData: productData,
                    currency: currency,
                    currencySymbol: currencySymbol,
                    onClick: () {
                      Navigator.pushNamed(context, '${ProductScreen.routeName}/$id');
                    },
                  );
                }),
              ],
              Padding(
                padding: const EdgeInsets.only(top: layoutPadding * 2, bottom: itemPaddingMedium),
                child: Text(
                  translate('order_billing_address'),
                  style: textTheme.titleMedium,
                ),
              ),
              Container(
                padding: paddingMedium,
                decoration: decoration,
                child: OrderBilling(billingData: billingData, style: textTheme.bodyMedium),
              ),
              Padding(
                padding: const EdgeInsets.only(top: layoutPadding * 2, bottom: itemPaddingMedium),
                child: Text(
                  translate('order_shipping_address'),
                  style: textTheme.titleMedium,
                ),
              ),
              Container(
                padding: paddingMedium,
                decoration: decoration,
                child: OrderBilling(billingData: shippingData, style: textTheme.bodyMedium),
              ),
              const SizedBox(height: layoutPadding * 2),
              buildItem(leading: translate('order_shipping'), trailing: price(_orderData!.shippingTotal)),
              buildItem(leading: translate('order_shipping_tax'), trailing: price(_orderData!.shippingTax)),
              buildItem(leading: translate('order_tax'), trailing: price(_orderData!.cartTax)),
              buildItem(leading: translate('order_discount'), trailing: price(_orderData!.discountTotal)),
              buildItem(leading: translate('order_discount_tax'), trailing: price(_orderData!.discountTax)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(translate('order_total'), style: textTheme.titleSmall),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(price(_orderData!.total), style: textTheme.titleLarge),
                    Text(translate('order_include'), style: textTheme.labelSmall)
                  ],
                )
              ]),
              const SizedBox(height: 48)
            ],
          ),
        );
      },
    );
  }

  Widget buildItem({
    String? title,
    String? subTitle,
    String? leading,
    String? trailing,
    Widget? status,
    EdgeInsetsDirectional? padding,
  }) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    Color? textColor = textTheme.titleMedium?.color;
    return Column(
      children: [
        Padding(
          padding: padding ?? EdgeInsetsDirectional.zero,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (leading != null) Text(leading, style: textTheme.bodySmall),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) Text(title, style: textTheme.bodySmall),
                if (subTitle != null) Text(subTitle, style: textTheme.titleSmall),
              ],
            ),
            if (trailing != null)
              Text(
                trailing,
                style: textTheme.bodySmall?.copyWith(color: textColor),
              ),
            if (status != null) status,
          ]),
        ),
        const Divider(height: itemPaddingExtraLarge, thickness: 1),
      ],
    );
  }
}
