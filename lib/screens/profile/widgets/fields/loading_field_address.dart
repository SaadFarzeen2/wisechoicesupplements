import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:flutter/material.dart';

class LoadingFieldAddress extends StatelessWidget {
  final int count;
  final bool borderFields;
  final Widget? titleModal;

  const LoadingFieldAddress({
    Key? key,
    this.count = 8,
    this.borderFields = false,
    this.titleModal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double width =
            constraints.maxWidth != double.infinity ? constraints.maxWidth : MediaQuery.of(context).size.width;
        return Wrap(
          spacing: 0,
          runSpacing: itemPaddingMedium,
          alignment: WrapAlignment.spaceBetween,
          children: [
            if (titleModal != null)
              Container(
                width: width,
                padding: const EdgeInsets.only(bottom: itemPaddingExtraLarge),
                child: Center(child: titleModal),
              ),
            ...List.generate(count, (index) {
              if (count > 5 && index < 2) {
                return LoadingFieldAddressItem(width: (width - itemPaddingMedium) / 2, borderFields: borderFields);
              }
              return LoadingFieldAddressItem(width: width, borderFields: borderFields);
            })
          ],
        );
      },
    );
  }
}

class LoadingFieldAddressItem extends StatelessWidget {
  final double width;
  final bool borderFields;

  const LoadingFieldAddressItem({
    Key? key,
    required this.width,
    this.borderFields = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    EdgeInsetsGeometry? padding = borderFields
        ? const EdgeInsets.symmetric(horizontal: itemPaddingMedium)
        : theme.inputDecorationTheme.contentPadding?.add(const EdgeInsets.symmetric(vertical: 0));

    return SizedBox(
      width: width,
      child: Stack(
        children: [
          TextFormField(
            enabled: false,
            decoration: borderFields
                ? InputDecoration(
                    contentPadding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )
                : null,
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: AlignmentDirectional.centerStart,
              padding: padding,
              child: CirillaShimmer(
                child: Container(
                  height: 16,
                  width: width - (padding?.horizontal ?? 0),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
