import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/widgets/cirilla_button_social.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class TabbarView extends StatelessWidget {
  final List<IconData> icons;
  final EdgeInsetsGeometry? padding;
  final int visit;
  final bool isVisitSuccess;

  const TabbarView({
    Key? key,
    required this.icons,
    this.visit = 0,
    this.isVisitSuccess = false,
    this.padding,
  })  : assert(visit < icons.length && visit > -1),
        super(key: key);

  Color getBackgroundColor({
    int index = 0,
    int select = 0,
    bool isSuccess = false,
    required ThemeData theme,
  }) {
    if (index < select || (index == select && isSuccess)) {
      return theme.primaryColor;
    }
    if (index == select && !isSuccess) {
      return theme.primaryColorLight;
    }
    return Colors.transparent;
  }

  Color getColorIcon({
    int index = 0,
    int select = 0,
    bool isSuccess = false,
    required ThemeData theme,
  }) {
    if (index < select || (index == select && isSuccess)) {
      return ColorBlock.white;
    }
    if (index == select && !isSuccess) {
      return theme.primaryColor;
    }
    return theme.colorScheme.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 0; i < icons.length; i++) ...[
            if (i > 0)
              Expanded(
                child: _DividerTabbar(color: i <= visit ? theme.primaryColor : theme.dividerColor),
              ),
            CirillaButtonSocial(
              icon: icons[i],
              sizeIcon: 20,
              background: getBackgroundColor(
                index: i,
                select: visit,
                isSuccess: isVisitSuccess,
                theme: theme,
              ),
              color: getColorIcon(
                index: i,
                select: visit,
                isSuccess: isVisitSuccess,
                theme: theme,
              ),
              isBorder: i > visit,
            )
          ],
        ],
      ),
    );
  }
}

class _DividerTabbar extends StatelessWidget {
  final Color color;

  const _DividerTabbar({
    Key? key,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      double width = constraints.maxWidth;
      Path customPathDashed = Path()
        ..moveTo(0, 0)
        ..lineTo(width, 0);

      return DottedBorder(
        customPath: (size) => customPathDashed,
        // PathBuilder
        color: color,
        dashPattern: const [2, 4],
        strokeWidth: 1,
        padding: EdgeInsets.zero,
        child: Container(),
      );
    });
  }
}
