import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:awesome_icons/awesome_icons.dart';

IconData? getIconData({Map? data}) {
  String name = get(data, ['name'], 'settings');
  String type = get(data, ['type'], 'feather');

  switch (type) {
    case 'awesome':
      return fontAwesomeIcons[name];
    default:
      return FeatherIconsMap[name];
  }
}

class CirillaIconBuilder extends StatelessWidget {
  final Map? data;
  final Color? color;
  final double? size;

  const CirillaIconBuilder({
    Key? key,
    this.data,
    this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(getIconData(data: data), color: color, size: size);
  }
}
