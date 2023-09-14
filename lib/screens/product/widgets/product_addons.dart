import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/screens/product/add_on/model.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product.dart';

import '../add_on/add_on.dart';

class ProductAddOns extends StatelessWidget with LoadingMixin {
  final Product? product;
  final Function onChange;
  final Map<String, AddOnData> value;
  final Map<String, String>? errors;

  const ProductAddOns({
    Key? key,
    this.product,
    required this.onChange,
    required this.value,
    this.errors,
  }) : super(key: key);

  _onChange(AddOnData option, Map<String, dynamic> item) {
    String fieldName = getFieldAddOn(item);
    Map<String, AddOnData> selected = Map<String, AddOnData>.of(value);
    selected.update(fieldName, (val) => option, ifAbsent: () => option);
    onChange(selected);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> metaData = product!.metaData!.firstWhere(
      (e) => e['key'] == 'product_addons',
      orElse: () => {'value': []},
    );
    return Container(
      child: metaData['value'].length > 0
          ? Column(
              children: List.generate(
                metaData['value'].length,
                (index) {
                  Map<String, dynamic> item = metaData['value'][index];
                  String fieldName = getFieldAddOn(item);
                  double padBottom = index < metaData['value'].length - 1 ? itemPaddingMedium : 0;
                  return Padding(
                    padding: EdgeInsets.only(bottom: padBottom),
                    child: _Field(
                      fieldName: fieldName,
                      item: item,
                      value: value[fieldName],
                      onChange: _onChange,
                      error: errors?[fieldName],
                    ),
                  );
                },
              ),
            )
          : null,
    );
  }
}

class _Field extends StatelessWidget {
  final String fieldName;
  final Map<String, dynamic> item;
  final AddOnData? value;
  final Function onChange;
  final String? error;

  const _Field({
    Key? key,
    required this.fieldName,
    required this.item,
    this.value,
    required this.onChange,
    this.error,
  }) : super(key: key);

  Widget buildField({
    bool showPrice = false,
    bool showDuration = false,
  }) {
    String type = item['type'];
    String display = item['display'];

    int min = ConvertData.stringToInt(item['min']);
    int max = ConvertData.stringToInt(item['max']);

    Widget? child;
    double padTop = itemPaddingSmall;

    if (type == 'custom_text' || type == 'custom_textarea') {
      String restrictionsType = get(item, ['restrictions_type'], 'any_text');
      child = TextFieldWidget(
        item: item,
        onChange: (value) => onChange(value, item),
        value: value,
        maxLines: type == 'custom_textarea' ? 8 : 1,
        restrictionsType: restrictionsType,
        max: max,
        min: min,
        error: error,
      );
    }
    if (type == 'multiple_choice') {
      bool required = get(item, ['required'], 0) == 1;

      child = MultipleChoice(
        value: value,
        options: item['options'],
        onChange: (option) => onChange(option, item),
        type: display,
        showPrice: showPrice,
        showDuration: showDuration,
        required: required,
        error: error,
      );

      if (display == 'radiobutton') {
        padTop = 0;
      }
    }

    if (type == 'checkbox') {
      child = CheckboxField(
        value: value,
        options: item['options'],
        onChange: (option) => onChange(option, item),
        showPrice: showPrice,
        showDuration: showDuration,
        error: error,
      );
      padTop = 0;
    }
    if (type == 'custom_price') {
      child = PriceField(
        item: item,
        onChange: (value) => onChange(value, item),
        value: value,
        min: min,
        max: max,
        error: error,
      );
    }

    if (type == 'input_multiplier') {
      child = QuantityField(
        item: item,
        onChange: (value) => onChange(value, item),
        value: value,
        min: min,
        max: max,
        error: error,
      );
    }
    if (child != null) {
      return Padding(padding: EdgeInsets.all(padTop), child: child);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String type = get(item, ['type'], '');

    String label = get(item, ['name'], '');
    bool showDescription = get(item, ['description_enable'], 0) == 1;
    String description = get(item, ['description'], '');

    if (type == 'heading') {
      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelField(label: label, type: 'heading'),
            if (showDescription && description.isNotEmpty) DescriptionField(description: description),
          ],
        ),
      );
    }
    String labelType = get(item, ['title_format'], 'label');
    bool require = get(item, ['required'], 0) == 1;

    bool adjustPrice = get(item, ['adjust_price'], 0) == 1;
    bool wcAppointmentHidePriceLabel = get(item, ['wc_appointment_hide_price_label'], 0) == 1;

    bool showDuration = get(item, ['wc_appointment_hide_duration_label'], 0) == 0;

    bool showPriceLabel = adjustPrice && !wcAppointmentHidePriceLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelType != 'hide') ...[
          LabelField(
            label: label,
            price: showPriceLabel ? getTextPrice(context, option: item) : null,
            textDuration: showDuration ? getTextDuration(context, option: item, translate: translate) : null,
            type: labelType,
            require: require,
          ),
          if (showDescription && description.isNotEmpty) const SizedBox(height: itemPaddingSmall),
        ],
        if (showDescription && description.isNotEmpty) DescriptionField(description: description),
        buildField(
          showPrice: !wcAppointmentHidePriceLabel,
          showDuration: showDuration,
        ),
      ],
    );
  }
}
