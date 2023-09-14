import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:flutter/material.dart';

import 'package:cirilla/screens/product/custom_field/custom_field.dart';

class PostAdvancedFieldsCustom extends StatelessWidget with Utility {
  final Post? post;
  final String? align;
  final String? fieldName;

  const PostAdvancedFieldsCustom({Key? key, this.post, this.align, this.fieldName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdvancedFieldsCustomView(
      fields: post?.afcFields,
      align: align,
      fieldName: fieldName,
    );
  }
}
