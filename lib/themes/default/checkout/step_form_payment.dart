import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class StepFormPayment extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPayment;

  const StepFormPayment({
    Key? key,
    this.padding,
    this.onPayment,
  }) : super(key: key);

  @override
  State<StepFormPayment> createState() => _StepFormPayment();
}

class _StepFormPayment extends State<StepFormPayment> {
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      padding: widget.padding ?? paddingVerticalLarge.add(paddingHorizontal),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(translate('checkout_card_information'), style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/images/payment/card_stripe.png', width: 24, height: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Credit Card Stripe',
                    style: theme.textTheme.titleSmall?.copyWith(color: theme.primaryColor),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name *',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email *',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Phone *',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Card Number *',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'MM/YY *',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'CVC *',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onPayment,
                child: Text(translate('checkout_payment_price', {'price': '\$ 210.00'})),
              ),
            )
          ],
        ),
      ),
    );
  }
}
