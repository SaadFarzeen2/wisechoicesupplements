import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_quantity.dart';
import 'package:flutter/material.dart';

class ProductQuantity extends StatelessWidget with ShapeMixin {
  final String? align;
  final int qty;
  final int? max;
  final ValueChanged<int>? onChanged;

  const ProductQuantity({
    Key? key,
    this.align = 'left',
    this.qty = 1,
    this.max,
    this.onChanged,
  }) : super(key: key);

  void buildModalEmpty(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      shape: borderRadiusTop(),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: paddingHorizontal.copyWith(top: itemPaddingMedium, bottom: itemPaddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                translate('product_quantity_min', {'min': '1'}),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context), child: Text(translate('product_quantity_agree'))),
              ),
            ],
          ),
        );
      },
    );
    future.then((void value) {
      onChanged!(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    AlignmentDirectional alignment = align == 'right'
        ? AlignmentDirectional.centerEnd
        : align == 'center'
            ? AlignmentDirectional.center
            : AlignmentDirectional.centerStart;
    if (max == null) {
      return const SizedBox();
    }
    return Container(
      alignment: alignment,
      child: CirillaQuantity(
        max: max,
        onChanged: onChanged,
        value: qty,
        color: Theme.of(context).colorScheme.surface,
        height: 48,
        radius: 8,
      ),
    );
  }
}
