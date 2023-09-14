import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:dio/dio.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';
import 'package:provider/provider.dart';

class SubscribeWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  const SubscribeWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);

  @override
  State<SubscribeWidget> createState() => _SubscribeWidgetState();
}

class _SubscribeWidgetState extends State<SubscribeWidget>
    with Utility, NavigationMixin, SnackMixin, LoadingMixin, ContainerMixin {
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _validateEmail = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;
    String lang = settingStore.locale;

    /// Config general
    Map<String, dynamic> headingData = widget.widgetConfig?.fields ?? {};
    String text = ConvertData.stringFromConfigs(get(headingData, ['title'], ''), lang)!;
    TextStyle titleStyle = ConvertData.toTextStyle(get(headingData, ['title'], ''), themeModeKey);
    String description = ConvertData.stringFromConfigs(get(headingData, ['description'], ''), lang)!;
    TextStyle descriptionStyle = ConvertData.toTextStyle(get(headingData, ['description'], ''), themeModeKey);
    String? placeHolder = ConvertData.stringFromConfigs(get(headingData, ['placeholder'], ''), lang);
    String? textButton = ConvertData.stringFromConfigs(get(headingData, ['txtButton', 'text'], ''), lang);

    String? formId = get(headingData, ['formId'], '');

    /// Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);
    Map? padding = get(styles, ['padding'], {});
    Map? margin = get(styles, ['margin'], {});
    String? image = ConvertData.imageFromConfigs(get(styles, ['image']), lang);

    Color colorIcon =
        ConvertData.fromRGBA(get(styles, ['colorIcon', themeModeKey], {}), theme.textTheme.titleMedium?.color);
    double sizeIcon = ConvertData.stringToDouble(get(styles, ['sizeIcon'], 20), 20);

    Color backgroundButton =
        ConvertData.fromRGBA(get(styles, ['backgroundButton', themeModeKey], {}), theme.primaryColor);
    Color colorButton = ConvertData.fromRGBA(get(styles, ['colorButton', themeModeKey], {}), Colors.white);

    Color backgroundInput =
        ConvertData.fromRGBA(get(styles, ['backgroundInput', themeModeKey], {}), Colors.transparent);
    Color colorInput =
        ConvertData.fromRGBA(get(styles, ['colorInput', themeModeKey], {}), theme.textTheme.titleMedium?.color);
    Color colorPlaceholder =
        ConvertData.fromRGBA(get(styles, ['colorPlaceholder', themeModeKey], {}), theme.textTheme.bodyMedium?.color);
    Color borderInput = ConvertData.fromRGBA(get(styles, ['borderInput', themeModeKey], {}), theme.dividerColor);

    RequestHelper requestHelper = Provider.of<RequestHelper>(context);

    return Container(
        padding: ConvertData.space(padding, 'padding'),
        margin: ConvertData.space(margin, 'margin'),
        decoration: decorationColorImage(color: background, image: image),
        width: double.infinity,
        child: SubscribeItem(
          icon: Icon(
            FeatherIcons.mail,
            size: sizeIcon,
            color: colorIcon,
          ),
          title: Text(
            text,
            style: theme.textTheme.titleLarge?.merge(titleStyle),
          ),
          content: Text(
            description,
            style: theme.textTheme.bodyMedium?.merge(descriptionStyle),
            textAlign: TextAlign.center,
          ),
          textField: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: placeHolder,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(color: colorPlaceholder),
              errorText: _validateEmail ? 'email is required' : null,
              filled: true,
              fillColor: backgroundInput,
              // fillColor: Colors.white,
              labelStyle: theme.textTheme.bodyLarge,
              contentPadding: const EdgeInsetsDirectional.only(start: 16, bottom: 2),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: borderInput),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: borderInput),
              ),
            ),
            cursorColor: colorInput,
            style: theme.textTheme.bodyLarge?.copyWith(color: colorInput),
          ),
          elevatedButton: ElevatedButton(
            onPressed: () async {
              setState(() {
                _loading = true;
              });
              try {
                Map<String, dynamic> res = await requestHelper.sendContact(queryParameters: {
                  'your-email': _emailController.text,
                }, formId: formId);
                if (res['status'] != 'mail_sent') {
                  if (mounted) showError(context, res['message']);
                } else {
                  if (mounted) showSuccess(context, res['message']);
                }
                setState(() {
                  _emailController.text.isEmpty ? _validateEmail = true : _validateEmail = false;
                  _emailController.clear();
                  _loading = false;
                });
              } on DioError catch (e) {
                showError(context, e);
                setState(() {
                  _loading = false;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: colorButton,
              backgroundColor: backgroundButton,
            ),
            child: _loading ? entryLoading(context, color: theme.colorScheme.onPrimary) : Text(textButton!),
          ),
        ));
  }
}
