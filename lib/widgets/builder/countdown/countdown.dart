import 'dart:async';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

class TimeItem {
  final int count;
  final String type;

  TimeItem({
    required this.count,
    required this.type,
  });
}

class CountdownWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  const CountdownWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> with Utility, NavigationMixin, ContainerMixin {
  List<TimeItem> times = [];
  Timer? timer;

  @override
  void initState() {
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    startTimer(fields);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  startTimer(Map<String, dynamic> fields) {
    String? timeExpire = get(fields, ['expireDate'], DateTime.now().toString());
    bool? enableDay = get(fields, ['enableDay'], true);
    bool? enableHour = get(fields, ['enableHour'], true);
    bool? enableMinute = get(fields, ['enableMinute'], true);
    bool? enableSecond = get(fields, ['enableSecond'], true);
    Duration ms = const Duration(seconds: 1);
    timer = Timer.periodic(ms, (timer) {
      DateTime expireDate = DateTime.parse(timeExpire!);
      DateTime nowDate = DateTime.now();

      Duration difference = expireDate.difference(nowDate);

      int diffTime = difference.inSeconds;
      int? day = enableDay! ? 0 : null;
      int? hour = enableHour! ? 0 : null;
      int? minute = enableMinute! ? 0 : null;
      int? second = enableSecond! ? 0 : null;
      if (diffTime <= 0) {
        timer.cancel();
      } else {
        day = day != null ? diffTime ~/ 86400 : null;
        hour = hour != null ? (diffTime % 86400) ~/ 3600 : null;
        minute = minute != null ? ((diffTime % 86400) % 3600) ~/ 60 : null;
        second = second != null ? ((diffTime % 86400) % 3600) % 60 : null;
      }
      List<TimeItem> listTime = [];

      if (day != null) {
        listTime.insert(listTime.length, TimeItem(count: day, type: 'd'));
      }
      if (hour != null) {
        listTime.insert(listTime.length, TimeItem(count: hour, type: 'h'));
      }
      if (minute != null) {
        listTime.insert(listTime.length, TimeItem(count: minute, type: 'm'));
      }
      if (second != null) {
        listTime.insert(listTime.length, TimeItem(count: second, type: 's'));
      }
      setState(() {
        times = listTime;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  List<String> convertTime(List<TimeItem> data, TranslateType translate) {
    List<String> timeData = [];
    for (int i = 0; i < data.length; i++) {
      TimeItem value = data[i];
      String str = '';
      switch (value.type) {
        case 'd':
          str = translate('count_day', {'count': '${value.count}'});
          break;
        case 'h':
          str = translate('count_hour', {'count': '${value.count}'});
          break;
        case 'm':
          str = translate('count_minus', {'count': '${value.count}'});
          break;
        default:
          str = translate('count_second', {'count': '${value.count}'});
      }
      timeData.add(str);
    }
    return timeData;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    String themeModeKey = settingStore.themeModeKey;
    String language = settingStore.locale;

    String layout = widget.widgetConfig!.layout ?? 'horizontal';

    // Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Map<String, dynamic>? margin = get(styles, ['margin'], {});
    Map<String, dynamic>? padding = get(styles, ['padding'], {});
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);
    double? pad = ConvertData.stringToDouble(get(styles, ['pad'], 16));

    // General config
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    Map<String, dynamic>? action = get(fields, ['action'], {});
    String? alignment = get(fields, ['alignment'], 'left');
    String textTitle = ConvertData.stringFromConfigs(get(fields, ['title'], ''), language)!;
    TextStyle textStyle = ConvertData.toTextStyle(get(fields, ['title'], {}), themeModeKey);

    String? route = get(action, ['route'], 'none');

    return Container(
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      decoration: decorationColorImage(color: background),
      child: GestureDetector(
        onTap: () => route != 'none' ? navigate(context, action) : null,
        child: buildLayout(
          layout,
          label: textTitle.isNotEmpty
              ? Text(
                  textTitle,
                  style: theme.textTheme.titleLarge?.merge(textStyle),
                )
              : null,
          time: buildTime(
              data: convertTime(times, translate),
              fields: fields,
              styles: styles,
              themeModeKey: themeModeKey,
              theme: theme),
          pad: pad,
          alignment: alignment,
        ),
      ),
    );
  }

  Widget buildLayout(String layout, {double? pad, String? alignment, Widget? label, Widget? time}) {
    switch (layout) {
      case 'vertical':
        return Vertical(
          label: label,
          time: time,
          pad: pad,
          alignment: alignment,
        );
      default:
        return Horizontal(
          label: label,
          time: time,
          pad: pad,
        );
    }
  }

  Widget buildTime({
    required List<String> data,
    Map<String, dynamic>? fields,
    Map<String, dynamic>? styles,
    String? themeModeKey,
    required ThemeData theme,
  }) {
    Color background = ConvertData.fromRGBA(get(styles, ['backgroundTime', themeModeKey], {}), theme.primaryColor);
    Color borderTime = ConvertData.fromRGBA(get(styles, ['borderTime', themeModeKey], {}), theme.primaryColor);
    Color textColor = ConvertData.fromRGBA(get(styles, ['textColor', themeModeKey], {}), Colors.white);
    Color separatorColor = ConvertData.fromRGBA(get(styles, ['separatorColor', themeModeKey], {}), theme.dividerColor);

    double pad = ConvertData.stringToDouble(get(styles, ['padTime'], 12));
    bool enableSeparator = get(fields, ['enableSeparator'], true);

    return TimeCount.itemTime(
      times: data,
      color: background,
      textStyle: theme.textTheme.titleSmall?.copyWith(color: textColor),
      border: Border.all(width: 2, color: borderTime),
      padding: paddingHorizontalTiny.copyWith(top: 1, bottom: 1),
      symbolStyle: theme.textTheme.titleSmall?.copyWith(color: separatorColor),
      widthSeparator: pad,
      symbol: enableSeparator ? ':' : '',
    );
  }
}

class Horizontal extends StatelessWidget {
  final Widget? label;
  final Widget? time;
  final double? pad;

  const Horizontal({
    Key? key,
    this.label,
    required this.time,
    this.pad = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: label ?? Container()),
        SizedBox(width: pad),
        time!,
      ],
    );
  }
}

class Vertical extends StatelessWidget {
  final Widget? label;
  final Widget? time;
  final double? pad;
  final String? alignment;

  const Vertical({
    Key? key,
    this.label,
    required this.time,
    this.pad = 16,
    this.alignment = 'left',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CrossAxisAlignment crossAxisAlignment = alignment == 'left'
        ? CrossAxisAlignment.start
        : alignment == 'right'
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.center;
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (label is Widget) ...[
          label!,
          SizedBox(height: pad),
        ],
        time!,
      ],
    );
  }
}
