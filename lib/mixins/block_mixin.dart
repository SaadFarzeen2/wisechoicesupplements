import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:ui/ui.dart';

mixin BlockMixin {
  Widget buildCircleNumber({
    dynamic number,
    Color? color,
    Color? textColor,
    double? size,
    required ThemeData theme,
  }) {
    double value = ConvertData.stringToDouble(number, 10);
    return BadgeUi(
      text: Text(
        value.truncateToDouble() == value ? value.toStringAsFixed(0) : '$value',
        style: theme.textTheme.titleSmall?.copyWith(color: textColor ?? Colors.white),
      ),
      color: color ?? ColorBlock.green,
      size: size ?? 40,
    );
  }

  Widget? buildPrice({
    String? currentPrice,
    String? oldPrice,
    Color? color,
    required ThemeData theme,
  }) {
    if (currentPrice == null || currentPrice.isEmpty) {
      return null;
    }
    TextStyle? style = theme.textTheme.titleMedium;
    if (oldPrice != null && oldPrice.isNotEmpty) {
      return Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            currentPrice,
            style: style!.copyWith(color: color ?? ColorBlock.red),
          ),
          if (oldPrice.isNotEmpty)
            Text(
              oldPrice,
              style: style.copyWith(color: theme.textTheme.bodyMedium?.color, decoration: TextDecoration.lineThrough),
            ),
        ],
      );
    }
    return Text(currentPrice, style: style!.copyWith(color: color));
  }

  Widget buildButtonCoupon({
    required String coupon,
    String? textButton,
    bool? maskCoupon,
    required bool checkExpire,
    String? maskCouponText,
    String? expireDate,
    Function? onButton,
    Function? onButtonCoupon,
    ThemeData? theme,
  }) {
    Widget button = !checkExpire || !maskCoupon!
        ? SizedBox(
            height: 34,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onButton as void Function()?,
              child: Text(textButton!),
            ),
          )
        : SizedBox(
            height: 34,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onButtonCoupon as void Function()?,
              child: Text(maskCouponText!),
            ),
          );

    Widget? couponWidget = coupon.isNotEmpty && (!checkExpire || !maskCoupon!)
        ? GestureDetector(
            onTap: checkExpire ? () => onButtonCoupon!() : null,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              padding: paddingHorizontalMedium,
              dashPattern: const [4, 3],
              color: theme!.dividerColor,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: paddingHorizontalLarge.add(paddingVerticalMedium),
                      child: Text(
                        coupon,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: checkExpire ? ColorBlock.green : theme.dividerColor,
                          decoration: !checkExpire ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 0,
                    bottom: 0,
                    end: 0,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Icon(
                        FontAwesomeIcons.copy,
                        size: 16,
                        color: !checkExpire ? theme.dividerColor : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : null;

    String textDate = !checkExpire ? 'Expired' : 'date';
    Widget? date = coupon.isNotEmpty && expireDate != null && expireDate.isNotEmpty
        ? Text(textDate, style: theme!.textTheme.bodySmall)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        button,
        if (couponWidget is Widget) ...[
          const SizedBox(height: 16),
          couponWidget,
        ],
        if (date is Widget) ...[
          const SizedBox(height: 4),
          date,
        ]
      ],
    );
  }
}
