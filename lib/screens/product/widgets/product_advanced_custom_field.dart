import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:cirilla/screens/product/custom_field/custom_field.dart';

Map getACFields(Product? product) {
  Map data = {
    ...?product?.afcFields,
  };
  List<Map<String, dynamic>>? meta = product?.metaData;
  if (meta?.isNotEmpty == true) {
    Map<String, dynamic>? barcode =
        meta!.firstWhereOrNull((element) => get(element, ['key'], '') == '_ywbc_barcode_image');

    Map<String, dynamic>? labelBarcode =
        meta.firstWhereOrNull((element) => get(element, ['key'], '') == 'ywbc_barcode_display_value_custom_field');

    String value = get(barcode, ['value'], '');
    String label = get(labelBarcode, ['value'], '');

    if (value.isNotEmpty) {
      data['_ywbc_barcode_image'] = {
        "key": "_ywbc_barcode_image",
        "label": label,
        "name": "_ywbc_barcode_image",
        "prefix": "acf",
        "type": "base64",
        "value": value,
      };
    }
  }
  return data;
}

/// Get Acf keys
List<String> getAcfKeys({Map<String, dynamic>? acf}) {
  // return empty string if acf not provider
  if (acf == null || acf.isEmpty) {
    return [];
  }

  return acf.keys.toList().cast<String>();
}

/// Get acf value
dynamic getAcfValue({Map<String, dynamic>? acf, required String key, dynamic defaultValue = ''}) {
  // return empty string if acf not provider
  if (acf == null || acf.isEmpty) {
    return defaultValue;
  }

  if (acf[key] == null) {
    return defaultValue;
  }

  return acf[key];
}

class ProductAdvancedFieldsCustom extends StatelessWidget with Utility {
  final Product? product;
  final String? align;
  final String? fieldName;

  const ProductAdvancedFieldsCustom({Key? key, this.product, this.align, this.fieldName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdvancedFieldsCustomView(
      fields: getACFields(product),
      align: align,
      fieldName: fieldName,
    );
  }
}
