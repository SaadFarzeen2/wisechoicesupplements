import 'package:flutter/material.dart';

class LayoutGrid extends StatelessWidget {
  final int length;
  final double pad;
  final EdgeInsetsDirectional? padding;
  final int col;
  final double ratio;
  final Widget Function(BuildContext context, {int? index, double? widthItem}) buildItem;

  const LayoutGrid({
    Key? key,
    this.length = 5,
    this.pad = 12,
    this.padding = EdgeInsetsDirectional.zero,
    this.col = 2,
    this.ratio = 1,
    required this.buildItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: col,
      childAspectRatio: ratio,
      shrinkWrap: true,
      crossAxisSpacing: pad,
      mainAxisSpacing: pad,
      padding: padding ?? EdgeInsets.zero,
      children: List.generate(length, (index) {
        return LayoutBuilder(builder: (_, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          return Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(),
            child: Column(
              children: [buildItem(context, index: index, widthItem: width)],
            ),
          );
        });
      }),
    );
  }
}
