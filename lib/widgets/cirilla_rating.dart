import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/widgets/cirilla_star.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';

class CirillaRating extends StatelessWidget {
  final double value;
  final int count;
  final double size;
  final Color? color;
  final double pad;

  const CirillaRating({
    Key? key,
    this.value = 0,
    this.count = 5,
    this.size = 12,
    this.color,
    this.pad = 4,
  })  : assert(count >= 0),
        assert(size > 0),
        assert(pad >= 0),
        assert(value >= 0 && value <= count),
        super(key: key);

  const factory CirillaRating.select({
    Key? key,
    int defaultRating,
    int count,
    double size,
    Color? color,
    Color? selectColor,
    double pad,
    Function(int value)? onFinishRating,
  }) = _CirillaRatingSelect;

  const factory CirillaRating.number({
    Key? key,
    double value,
    double iconSize,
    double fontSize,
    Color? iconColor,
    Color? textColor,
    double pad,
  }) = _CirillaRatingNumber;

  String get getStar {
    if (value > 5) return '5';
    if (value < 0) return '0';

    int ceil = value.ceil(); // 2.4 => 2
    double small = ceil + 0.2; // 2.4 => 2.2
    double middle = ceil + 0.5; // 2.4 => 2.5
    int floor = value.floor(); // 2.4 => 3
    double large = floor - 0.2; // 2.4 => 2.8

    if (value < small) {
      return '$ceil';
    } else if (value < large) {
      return '$middle';
    }

    return '$floor';
  }

  @override
  Widget build(BuildContext context) {
    return CirillaStar(star: getStar);
  }
}

class _CirillaRatingSelect extends CirillaRating {
  final int defaultRating;
  final Function(int value)? onFinishRating;
  final Color? selectColor;

  const _CirillaRatingSelect({
    Key? key,
    this.onFinishRating,
    this.defaultRating = 3,
    int count = 5,
    double size = 20,
    Color? color,
    this.selectColor,
    double pad = 4,
  })  : assert(count > 0),
        assert(size > 0),
        assert(pad >= 0),
        assert(defaultRating >= 0 && defaultRating <= count),
        super(
          key: key,
          count: count,
          size: size,
          color: color,
          pad: pad,
        );

  @override
  Widget build(BuildContext context) {
    Color colorSelect = selectColor ?? ColorBlock.yellow;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        IconData icon = index < defaultRating ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star;
        Color? colorIcon = index < defaultRating ? colorSelect : color;
        double padRight = index <= count - 1 ? pad : 0;
        return Padding(
          padding: EdgeInsets.only(right: padRight),
          child: InkWell(
            onTap: () => onFinishRating!(index + 1),
            child: Icon(
              icon,
              size: size,
              color: colorIcon,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CirillaRatingNumber extends CirillaRating {
  final Color? iconColor;
  final Color? textColor;
  final double fontSize;
  final double iconSize;

  const _CirillaRatingNumber({
    Key? key,
    double value = 2.5,
    this.iconSize = 12,
    this.fontSize = 14,
    this.iconColor,
    this.textColor,
    double pad = 4,
  })  : assert(value >= 0),
        assert(iconSize > 0 && fontSize > 0),
        assert(pad >= 0),
        super(
          key: key,
          value: value,
          pad: pad,
        );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: pad,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '$value',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: fontSize, color: textColor),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Icon(FontAwesomeIcons.solidStar, size: iconSize, color: iconColor ?? ColorBlock.yellow),
        ),
      ],
    );
  }
}
