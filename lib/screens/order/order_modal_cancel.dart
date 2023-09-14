import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/order/order.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class OrderModalCancel extends StatelessWidget {
  final OrderData? order;
  final List<dynamic>? orderCancel;
  final Function(String)? onPressed;
  const OrderModalCancel({
    super.key,
    this.order,
    this.orderCancel,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    final formKey = GlobalKey<FormState>();
    final messController = TextEditingController();
    String confirmNote = get(orderCancel?[0], ['confirm-note'], '');
    bool textRequired = get(orderCancel?[0], ['text-required'], '0') == '1';
    InputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: theme.primaryColor),
      borderRadius: BorderRadius.circular(5.0),
    );
    return BadgeUi(
      text: Text(
        translate('order_cancel'),
        style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
      ),
      color: theme.primaryColor,
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: borderRadiusBottomSheet,
          ),
          builder: (_) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 140,
              child: SingleChildScrollView(
                padding: paddingHorizontal.add(paddingVerticalExtraLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        translate('order_request'),
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: paddingVerticalTiny,
                      child: Text(
                        translate('order_title', {'id': '#${order?.id}'}),
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    CirillaHtml(html: confirmNote),
                    Padding(
                      padding: paddingVerticalTiny,
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          minLines: 7,
                          maxLines: 15,
                          controller: messController,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsetsDirectional.only(start: itemPaddingMedium, top: itemPaddingMedium),
                            labelText: translate('order_cancellation_details'),
                            labelStyle: Theme.of(context).textTheme.bodyLarge,
                            border: const OutlineInputBorder(borderRadius: borderRadius),
                            alignLabelWithHint: true,
                            focusedBorder: inputBorder,
                            enabledBorder: inputBorder,
                            errorBorder: inputBorder,
                          ),
                          validator: (value) {
                            if (value!.isEmpty && textRequired) {
                              return translate('contact_mess_is_required');
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            messController.clear();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(130, 40),
                            backgroundColor: theme.colorScheme.onSurface,
                          ),
                          child: Text(translate('brand_cancel')),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              onPressed!(messController.text);
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(minimumSize: const Size(130, 40)),
                          child: Text(translate('checkout_confirm')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
