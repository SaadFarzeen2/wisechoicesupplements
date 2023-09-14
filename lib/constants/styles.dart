import 'package:flutter/material.dart';

const double itemPadding = 8;

const double itemPaddingSmall = 12;

const double itemPaddingMedium = 16;

const double itemPaddingLarge = 24;

const double itemPaddingExtraLarge = 32;

const double layoutPadding = 20;

const double secondItemPaddingTiny = 2;

const double secondItemPaddingSmall = 10;

// padding
const EdgeInsets paddingTiny = EdgeInsets.all(8);

const EdgeInsets paddingSmall = EdgeInsets.all(12);

const EdgeInsets paddingMedium = EdgeInsets.all(16);

const EdgeInsets paddingLarge = EdgeInsets.all(24);

const EdgeInsets paddingExtraLarge = EdgeInsets.all(32);

const EdgeInsets paddingDefault = EdgeInsets.all(20);

const EdgeInsets secondPaddingMedium = EdgeInsets.all(14);

const EdgeInsets secondPaddingSmall = EdgeInsets.all(10);

const EdgeInsets secondPaddingTiny = EdgeInsets.all(2);

// padding horizontal
const EdgeInsets paddingHorizontalTiny = EdgeInsets.symmetric(horizontal: 8);

const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(horizontal: 12);

const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: 16);

const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: 24);

const EdgeInsets paddingHorizontalExtraLarge = EdgeInsets.symmetric(horizontal: 32);

const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: 20);

const EdgeInsets secondPaddingHorizontalTiny = EdgeInsets.symmetric(horizontal: 2);

const EdgeInsets secondPaddingHorizontalSmall = EdgeInsets.symmetric(horizontal: 10);

// padding vertical
const EdgeInsets paddingVerticalTiny = EdgeInsets.symmetric(vertical: 8);

const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(vertical: 12);

const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(vertical: 16);

const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(vertical: 24);

const EdgeInsets paddingVerticalExtraLarge = EdgeInsets.symmetric(vertical: 32);

const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: 20);

const EdgeInsets secondPaddingVerticalTiny = EdgeInsets.symmetric(vertical: 2);

const EdgeInsets secondPaddingVerticalSmall = EdgeInsets.symmetric(vertical: 10);

const BorderRadius borderRadius = BorderRadius.all(Radius.circular(8));
const BorderRadius borderRadiusTiny = BorderRadius.all(Radius.circular(4));
const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(16));
const BorderRadius borderRadiusExtraLarge = BorderRadius.all(Radius.circular(20));

const BorderRadius borderRadiusBottomSheet = BorderRadius.only(
  topLeft: Radius.circular(20),
  topRight: Radius.circular(20),
);

const BorderRadius borderRadiusBottomSheetLarge = BorderRadius.only(
  topLeft: Radius.circular(30),
  topRight: Radius.circular(30),
);

const List<BoxShadow> initBoxShadow = [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    offset: Offset(0, 4),
    blurRadius: 24,
    spreadRadius: 0,
  ),
];

const List<BoxShadow> secondBoxShadow = [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    spreadRadius: 2,
    blurRadius: 8,
    offset: Offset(0, 5),
  ),
];

const SizedBox sizeBoxLarge = SizedBox(height: 24);

/// The gradient over the canvas black to transparent
const BoxDecoration overlayContainer = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter, // 10% of the width, so there are ten blinds.
    colors: <Color>[
      Colors.black,
      Colors.transparent,
    ], // the gradient over the canvas
  ),
);
