import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class StepPayment extends StatelessWidget {
  final Widget paymentMethod;
  final Widget bottomWidget;
  final EdgeInsetsGeometry? padding;
  final double padHorizontal;

  const StepPayment({
    Key? key,
    required this.paymentMethod,
    required this.bottomWidget,
    this.padding,
    this.padHorizontal = layoutPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(padHorizontal, 0, padHorizontal, 8),
                  child: Text(translate('checkout_payment_method'), style: theme.textTheme.titleLarge),
                ),
                paymentMethod,
              ],
            ),
          ),
        ),
        bottomWidget,
      ],
    );
  }

  Widget buildContent({
    required TranslateType translate,
    required ThemeData theme,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 32),
          InkWell(
            onTap: () => {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(translate('checkout_billing_address'), style: theme.textTheme.titleLarge),
                Text(
                  translate('checkout_edit_address'),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Mainjs', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('123 Khuat Duy Tien, Ha Noi, 100000, VietNam', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 32),
          TextFormField(
            decoration: InputDecoration(hintText: translate('checkout_note')),
            maxLines: 5,
          )
        ],
      ),
    );
  }
}
