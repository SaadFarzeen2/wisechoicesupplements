import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonWidget extends StatelessWidget with Utility, NavigationMixin, ContainerMixin {
  final WidgetConfig? widgetConfig;

  ButtonWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;
    String language = settingStore.locale;

    // Styles
    Map<String, dynamic> styles = widgetConfig?.styles ?? {};
    Map<String, dynamic>? margin = get(styles, ['margin'], {});
    Map<String, dynamic>? padding = get(styles, ['padding'], {});
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);
    double height = ConvertData.stringToDouble(get(styles, ['height'], 48));
    double radius = ConvertData.stringToDouble(get(styles, ['radiusItem'], 8), 8);

    Color backgroundItem = ConvertData.fromRGBA(get(styles, ['backgroundItem', themeModeKey], {}), theme.primaryColor);
    Color borderColor = ConvertData.fromRGBA(get(styles, ['borderColorItem', themeModeKey], {}), Colors.transparent);
    double borderWidth = ConvertData.stringToDouble(get(styles, ['borderWidgetItem'], 0));

    bool autoIconItem = get(styles, ['autoIconItem'], false);
    double iconSize = ConvertData.stringToDouble(get(styles, ['iconSizeItem'], 14), 14);
    Color iconColor = ConvertData.fromRGBA(get(styles, ['iconColorItem', themeModeKey], {}), Colors.white);

    // General config
    Map<String, dynamic> fields = widgetConfig?.fields ?? {};
    dynamic title = get(fields, ['title'], {});
    Map<String, dynamic>? action = get(fields, ['action'], {});
    Map icon = get(fields, ['icon'], {});
    bool enableIcon = get(fields, ['enableIcon'], true);
    bool? enableIconLeft = get(fields, ['enableIconLeft'], true);
    bool enableFullWidth = get(fields, ['enableFullWidth'], true);

    String textTitle = ConvertData.stringFromConfigs(title, language)!;
    TextStyle styleTitle = ConvertData.toTextStyle(title, themeModeKey);
    TextStyle? styleTextButton = theme.textTheme.bodyLarge?.merge(styleTitle);

    String? typeAction = get(action, ['type'], 'none');

    Widget iconWidget = CirillaIconBuilder(
      data: icon,
      size: autoIconItem ? iconSize : styleTextButton?.fontSize,
      color: autoIconItem ? iconColor : styleTextButton?.color,
    );

    return Container(
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      decoration: decorationColorImage(color: background),
      child: buildFullButton(
        isFull: enableFullWidth,
        child: SizedBox(
          height: height,
          child: ElevatedButton(
            onPressed: () => typeAction != 'none' ? navigate(context, action) : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: styleTitle.color,
              backgroundColor: backgroundItem,
              padding: paddingHorizontalLarge.add(paddingVerticalSmall),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: BorderSide(width: borderWidth, color: borderColor),
              ),
              textStyle: styleTextButton,
              shadowColor: Colors.transparent,
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (enableIcon && enableIconLeft!) iconWidget,
                if (enableIcon && enableIconLeft!) const SizedBox(width: 8),
                Text(textTitle),
                if (enableIcon && !enableIconLeft!) const SizedBox(width: 8),
                if (enableIcon && !enableIconLeft!) iconWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? buildFullButton({Widget? child, required bool isFull}) {
    if (isFull) {
      return child;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        child!,
      ],
    );
  }
}
