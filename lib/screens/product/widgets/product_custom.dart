import 'package:cirilla/mixins/navigation_mixin.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/builder/product_detail_value.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_icon_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCustom extends StatelessWidget with Utility, NavigationMixin {
  final ProductDetailValue configs;
  final String align;

  const ProductCustom({Key? key, required this.configs, this.align = 'left'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double widthView =
            constraints.maxWidth != double.infinity ? constraints.maxWidth : MediaQuery.of(context).size.width;

        return _buildLayer(context, configs: configs, widthView: widthView);
      },
    );
  }

  Widget _buildLayer(BuildContext context, {required ProductDetailValue configs, required double widthView}) {
    ThemeData theme = Theme.of(context);

    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;
    String languageKey = settingStore.languageKey;

    // Text
    String text = get(configs.text, [languageKey], '');
    TextStyle textStyle = ConvertData.toTextStyle(configs.text, themeModeKey);

    Widget child = Text(text, style: textStyle);

    if (configs.customType == 'button') {
      Map<String, dynamic>? buttonBg = get(configs.buttonBg, [themeModeKey], null);
      Map<String, dynamic>? buttonBorderColor = get(configs.buttonBorderColor, [themeModeKey], null);
      double borderWidth = configs.buttonBorderWidth ?? 0;

      Size size = configs.buttonSize ?? const Size(80, 32);
      child = Container(
        width: size.width > widthView ? widthView : size.width,
        height: size.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ConvertData.fromRGBA(buttonBg, theme.primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(configs.buttonBorderRadius ?? 0)),
          border: Border.all(color: ConvertData.fromRGBA(buttonBorderColor, theme.primaryColor), width: borderWidth),
        ),
        child: child,
      );
    }

    if (configs.customType == 'image') {
      String? src = get(configs.image, ['src'], '');
      Size size = configs.imageSize ?? const Size(32, 32);
      double imageWidth = size.width > widthView ? widthView : size.width;
      double imageHeight = (imageWidth * size.height) / size.width;
      child = src != ''
          ? Image.network(
              src!,
              width: imageWidth,
              height: imageHeight,
            )
          : Container();
    }

    if (configs.customType == 'icon') {
      Map<String, dynamic>? icon = configs.icon;
      double? iconSize = configs.iconSize;
      Map<String, dynamic>? iconColor = get(configs.iconColor, [themeModeKey], null);
      child = CirillaIconBuilder(
        data: icon,
        size: iconSize,
        color: ConvertData.fromRGBA(iconColor, theme.primaryColor),
      );
    }

    CrossAxisAlignment crossAxisAlignment = align == 'center'
        ? CrossAxisAlignment.center
        : align == 'right'
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        InkWell(
          onTap: () => navigate(context, configs.action),
          child: child,
        )
      ],
    );
  }
}
