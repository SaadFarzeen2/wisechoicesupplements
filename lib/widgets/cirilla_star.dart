import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/constants/color_block.dart';
import 'package:flutter/material.dart';

class Star extends StatelessWidget {
  const Star({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      key: Key('star'),
      padding: EdgeInsets.only(right: 4),
      child: Icon(FontAwesomeIcons.star, size: 12, color: ColorBlock.yellow),
    );
  }
}

class StarHalf extends StatelessWidget {
  const StarHalf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      key: Key('starHalfAlt'),
      padding: EdgeInsets.only(right: 4),
      child: Icon(FontAwesomeIcons.starHalfAlt, size: 12, color: ColorBlock.yellow),
    );
  }
}

class StarSolid extends StatelessWidget {
  const StarSolid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      key: Key('solidStar'),
      padding: EdgeInsets.only(right: 4),
      child: Icon(FontAwesomeIcons.solidStar, size: 12, color: ColorBlock.yellow),
    );
  }
}

const Map<String, List<Widget>> starList = {
  '0': [
    Star(),
    Star(),
    Star(),
    Star(),
    Star(),
  ],
  '0.5': [
    StarHalf(),
    Star(),
    Star(),
    Star(),
    Star(),
  ],
  '1': [
    StarSolid(),
    Star(),
    Star(),
    Star(),
    Star(),
  ],
  '1.5': [
    StarSolid(),
    StarHalf(),
    Star(),
    Star(),
    Star(),
  ],
  '2': [
    StarSolid(),
    StarSolid(),
    Star(),
    Star(),
    Star(),
  ],
  '2.5': [
    StarSolid(),
    StarSolid(),
    StarHalf(),
    Star(),
    Star(),
  ],
  '3': [
    StarSolid(),
    StarSolid(),
    StarSolid(),
    Star(),
    Star(),
  ],
  '3.5': [
    StarSolid(),
    StarSolid(),
    StarSolid(),
    StarHalf(),
    Star(),
  ],
  '4': [
    StarSolid(),
    StarSolid(),
    StarSolid(),
    StarSolid(),
    Star(),
  ],
  '4.5': [
    StarSolid(),
    StarSolid(),
    StarSolid(),
    StarSolid(),
    StarHalf(),
  ],
  '5': [
    StarSolid(),
    StarSolid(),
    StarSolid(),
    StarSolid(),
    StarSolid(),
  ],
};

class CirillaStar extends StatelessWidget {
  final String star;

  const CirillaStar({Key? key, required this.star}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: starList.containsKey(star) ? starList[star]! : [const SizedBox()],
    );
  }
}
