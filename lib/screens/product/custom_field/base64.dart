import 'dart:convert';
import 'dart:typed_data';

import 'package:cirilla/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';

class Base64Image extends StatelessWidget with Utility {
  final String label;
  final dynamic value;

  const Base64Image({
    Key? key,
    this.value,
    this.label = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value is String && value.isNotEmpty == true) {
      Uint8List bytesImage = const Base64Decoder().convert(value);

      return Container(
        color: Colors.white,
        padding: paddingVerticalSmall,
        child: Column(
          children: [
            Image.memory(bytesImage),
            if (label.isNotEmpty) ...[
              const SizedBox(height: itemPadding),
              Text(label, style: const TextStyle(color: Colors.black))
            ],
          ],
        ),
      );
    }
    return Container();
  }
}
