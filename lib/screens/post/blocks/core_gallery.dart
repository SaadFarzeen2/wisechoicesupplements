import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';

import 'core_image.dart';

double pad = 10;

class BlockGallery extends StatelessWidget {
  final Map<String, dynamic>? block;

  const BlockGallery({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final attr = block?['attrs'];
    final columns = attr is Map ? attr['columns'] : null;
    int? cols = columns != null ? ConvertData.stringToInt(columns, 1) : null;

    List coreImages = block?['innerBlocks'] is List ? block!['innerBlocks'] : [];

    if (coreImages.isEmpty) return Container();

    int col = cols ?? (coreImages.length < 3 ? coreImages.length : 2);
    int row = (coreImages.length / col).ceil();

    return Column(
      children: List.generate(row, (i) {
        double padBottom = i < row - 1 ? 10 : 0;
        return Padding(
          padding: EdgeInsets.only(bottom: padBottom),
          child: Row(
            children: [
              for (int j = 0; j < col; j++) ...[
                Expanded(
                  child: i * col + j < coreImages.length ? BlockImage(block: coreImages[i * col + j]) : Container(),
                ),
                if (j < col - 1) const SizedBox(width: 10),
              ]
            ],
          ),
        );
      }),
    );
  }
}
