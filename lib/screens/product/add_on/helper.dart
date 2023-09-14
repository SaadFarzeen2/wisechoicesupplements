import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/screens/product/add_on/model.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

String getFieldAddOn(Map<String, dynamic> item) {
  return 'addon-${item['field_name']}';
}

String getTextPrice(BuildContext context, {required Map option}) {
  String price = '${get(option, ['price'], '')}';
  String priceType = get(option, ['price_type'], 'flat_fee');
  if (price.isNotEmpty) {
    if (priceType == 'flat_fee') {
      return formatCurrency(context, price: price);
    }
    if (priceType == 'quantity_based') {
      return formatCurrency(context, price: price);
    }
    return '$price%';
  }
  return '';
}

String getTextDuration(BuildContext context, {required Map option, required TranslateType translate}) {
  String duration = get(option, ['duration'], '');
  double time = ConvertData.stringToDouble(duration);

  if (duration.isNotEmpty) {
    if (time > 1) {
      return translate('product_appointment_durations', {
        'duration': duration,
      });
    }

    return translate('product_appointment_duration', {
      'duration': duration,
    });
  }
  return '';
}

double getPrice(BuildContext context, {required Map option}) {
  String price = '${get(option, ['price'], '')}';

  return ConvertData.stringToDouble(price);
}

double getDuration(BuildContext context, {required Map option}) {
  String price = get(option, ['duration'], '');

  return ConvertData.stringToDouble(price);
}

double getAddonPriceAppointment({required Map<String, AddOnData> data, required double price, required int qty}) {
  double result = 0;

  if (data.isNotEmpty) {
    for (String key in data.keys) {
      AddOnData addOn = data[key]!;
      if (addOn.type == AddOnDataType.string) {
        result += _getValuePrice(
          price: addOn.string?.price ?? 0,
          priceType: addOn.string?.priceType ?? 'flat_fee',
          qty: addOn.string?.qty ?? 1,
          priceProduct: price,
          qtyProduct: qty,
        );
      } else if (addOn.type == AddOnDataType.option) {
        result += _getValuePrice(
          price: addOn.option?.price ?? 0,
          priceType: addOn.option?.priceType ?? 'flat_fee',
          qty: addOn.option?.qty ?? 1,
          priceProduct: price,
          qtyProduct: qty,
        );
      } else if (addOn.type == AddOnDataType.listOption) {
        List<AddOnOption> options = addOn.listOption ?? [];
        double priceOption = 0;
        for (AddOnOption option in options) {
          priceOption += _getValuePrice(
            price: option.price,
            priceType: option.priceType,
            qty: option.qty,
            priceProduct: price,
            qtyProduct: qty,
          );
        }
        result += priceOption;
      }
    }
  }

  return result;
}

double _getValuePrice({
  required double price,
  required String priceType,
  required int qty,
  required double priceProduct,
  required int qtyProduct,
}) {
  double result = 0;

  if (priceType == 'quantity_based') {
    return price * qty * qtyProduct;
  } else if (priceType == 'percentage_based') {
    double valuePrice = (priceProduct * price) / 100;
    return valuePrice * qty * qtyProduct;
  } else {
    result = price * qty;
  }

  return result;
}

double getAddonDurationAppointment({required Map<String, AddOnData> data, required int qty}) {
  double result = 0;

  if (data.isNotEmpty) {
    for (String key in data.keys) {
      AddOnData addOn = data[key]!;
      if (addOn.type == AddOnDataType.string) {
        result += _getValueDuration(
          duration: addOn.string?.duration ?? 0,
          durationType: addOn.string?.durationType ?? 'flat_time',
          qty: addOn.string?.qty ?? 1,
          qtyProduct: qty,
        );
      } else if (addOn.type == AddOnDataType.option) {
        result += _getValueDuration(
          duration: addOn.option?.duration ?? 0,
          durationType: addOn.option?.durationType ?? 'flat_time',
          qty: addOn.option?.qty ?? 1,
          qtyProduct: qty,
        );
      } else if (addOn.type == AddOnDataType.listOption) {
        List<AddOnOption> options = addOn.listOption ?? [];
        double durationOption = 0;
        for (AddOnOption option in options) {
          durationOption += _getValueDuration(
            duration: option.duration,
            durationType: option.durationType,
            qty: option.qty,
            qtyProduct: qty,
          );
        }
        result += durationOption;
      }
    }
  }

  return result;
}

double _getValueDuration({
  required double duration,
  required String durationType,
  required int qty,
  required int qtyProduct,
}) {
  double result = 0;

  if (durationType == 'quantity_based') {
    return duration * qty * qtyProduct;
  } else {
    result = duration * qty;
  }

  return result;
}
