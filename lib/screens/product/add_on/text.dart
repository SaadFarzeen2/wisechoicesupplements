import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/product/add_on/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helper.dart';

class TextFieldWidget extends StatelessWidget with Utility {
  final Map<String, dynamic> item;
  final Function onChange;
  final AddOnData? value;
  final String restrictionsType;
  final int? maxLines;
  final int max;
  final int min;
  final String? error;

  const TextFieldWidget({
    Key? key,
    required this.item,
    required this.onChange,
    this.value,
    required this.restrictionsType,
    this.maxLines,
    this.max = 0,
    this.min = 0,
    this.error,
  }) : super(key: key);

  _onChange(BuildContext context, String str) {
    bool adjustPrice = get(item, ['adjust_price'], 0) == 1;
    String priceType = get(item, ['price_type'], 'flat_fee');
    double price = adjustPrice ? getPrice(context, option: item) : 0;

    bool adjustDuration = get(item, ['adjust_duration'], 0) == 1;
    String durationType = get(item, ['duration_type'], 'flat_time');
    double duration = adjustDuration ? getDuration(context, option: item) : 0;

    onChange(
      AddOnData(
        type: AddOnDataType.string,
        string: AddOnString(
          value: str,
          price: price,
          duration: duration,
          priceType: priceType,
          durationType: durationType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType = restrictionsType == 'only_numbers'
        ? TextInputType.number
        : restrictionsType == 'email'
            ? TextInputType.emailAddress
            : TextInputType.text;
    return TextFormField(
      initialValue: value?.string?.value,
      onChanged: (String v) => _onChange(context, v),
      maxLines: maxLines,
      maxLength: max > 0 ? max : null,
      keyboardType: keyboardType,
      inputFormatters: keyboardType == TextInputType.number ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(errorText: error),
    );
  }
}
