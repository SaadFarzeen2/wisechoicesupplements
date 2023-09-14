import 'package:cirilla/constants/styles.dart';
import 'package:flutter/material.dart';

class CirillaFixedBottom extends StatelessWidget {
  final Widget child;
  final Widget childBottom;
  final EdgeInsetsGeometry? paddingChildBottom;

  const CirillaFixedBottom({
    Key? key,
    required this.child,
    required this.childBottom,
    this.paddingChildBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: child,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: paddingChildBottom ?? EdgeInsets.zero,
            child: childBottom,
          ),
        ),
      ],
    );
  }
}

class CirillaFixedBottomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const CirillaFixedBottomContainer({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: initBoxShadow,
      ),
      child: child,
    );
  }
}
