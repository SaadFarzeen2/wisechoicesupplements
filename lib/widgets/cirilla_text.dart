import 'package:flutter/material.dart';

class CirillaText extends StatelessWidget {
  final String? text;

  const CirillaText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text!, style: Theme.of(context).textTheme.titleSmall);
  }
}

class CirillaSubText extends StatelessWidget {
  final String text;
  final bool active;

  const CirillaSubText(this.text, {Key? key, this.active = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? activeColor = Theme.of(context).textTheme.displayLarge?.color;
    TextStyle? style = Theme.of(context).textTheme.bodyMedium;
    TextStyle? styleActive = Theme.of(context).textTheme.bodyMedium?.apply(color: activeColor);

    return Text(text, style: active ? styleActive : style);
  }
}
