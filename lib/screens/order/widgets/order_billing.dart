import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class OrderBilling extends StatefulWidget {
  final TextStyle? style;
  final Map? billingData;

  const OrderBilling({
    Key? key,
    this.style,
    this.billingData,
  }) : super(key: key);
  @override
  State<OrderBilling> createState() => _OrderBillingState();
}

class _OrderBillingState extends State<OrderBilling> with Utility {
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String firstName = get(widget.billingData, ['first_name'], '');
    String lastName = get(widget.billingData, ['last_name'], '');
    String address1 = get(widget.billingData, ['address_1'], '');
    String email = get(widget.billingData, ['email'], '');
    String phone = get(widget.billingData, ['phone'], '');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$firstName $lastName',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          address1,
          style: widget.style,
        ),
        Text('\n', style: widget.style),
        Text(
          translate('order_billing_email', {
            'email': email,
          }),
          style: widget.style,
        ),
        Text(
          translate('order_billing_phone', {
            'phone': phone,
          }),
          style: widget.style,
        ),
      ],
    );
  }
}
