import 'dart:math';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/screens/product/widgets/product_appointment/time_stamp_item.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';

import '../../../../models/product/staff_model.dart';

class ListTimeStamp extends StatelessWidget {
  const ListTimeStamp({
    Key? key,
    required this.activeHours,
    required this.onPickTimeStamp,
    this.pickedTime,
    required this.scheduledTimes,
    required this.activeHoursData,
    required this.staffId,
    required this.staffs,
  }) : super(key: key);
  final List<DateTime> activeHours;
  final String? staffId;
  final Function(DateTime? time) onPickTimeStamp;
  final DateTime? pickedTime;
  final List<DateTime> scheduledTimes;
  final Map<String, dynamic>? activeHoursData;
  final List<StaffModel> staffs;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    int maxItem = 0;
    int numMor = 0;
    int numAf = 0;
    int numEv = 0;
    if (activeHours.isNotEmpty) {
      List<Widget> listMorning = [
        Text(translate('product_appointment_morning'), style: theme.textTheme.bodyMedium),
        ...List.generate(activeHours.length, (index) {
          if (activeHours[index].hour >= 0 && activeHours[index].hour < 12) {
            numMor++;
            return TimeStampItem(
              staffs: staffs,
              dateTime: activeHours[index],
              pickedTime: pickedTime,
              onPickTimeStamp: (time) {
                onPickTimeStamp(time);
              },
              staffId: staffId,
              activeHoursData: activeHoursData,
              scheduleTimes: scheduledTimes,
            );
          } else {
            return const SizedBox.shrink();
          }
        }).toList()
      ];
      List<Widget> listAfternoon = [
        Text(translate('product_appointment_afternoon'), style: theme.textTheme.bodyMedium),
        ...List.generate(activeHours.length, (index) {
          if (activeHours[index].hour >= 12 && activeHours[index].hour < 17) {
            numAf++;
            return TimeStampItem(
              staffs: staffs,
              dateTime: activeHours[index],
              pickedTime: pickedTime,
              staffId: staffId,
              onPickTimeStamp: (time) {
                onPickTimeStamp(time);
              },
              activeHoursData: activeHoursData,
              scheduleTimes: scheduledTimes,
            );
          } else {
            return const SizedBox.shrink();
          }
        }).toList()
      ];
      List<Widget> listEvening = [
        Text(translate('product_appointment_evening'), style: theme.textTheme.bodyMedium),
        ...List.generate(activeHours.length, (index) {
          if (activeHours[index].hour >= 17 && activeHours[index].hour < 24) {
            numEv++;
            return TimeStampItem(
              staffs: staffs,
              dateTime: activeHours[index],
              pickedTime: pickedTime,
              onPickTimeStamp: (time) {
                onPickTimeStamp(time);
              },
              staffId: staffId,
              activeHoursData: activeHoursData,
              scheduleTimes: scheduledTimes,
            );
          } else {
            return const SizedBox.shrink();
          }
        }).toList()
      ];
      maxItem = max(numMor, numAf);
      maxItem = max(maxItem, numEv);
      double maxHeight = 30.0 + 60.0 * maxItem;
      return SizedBox(
        height: maxHeight,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: listMorning,
              ),
            ),
            const SizedBox(width: itemPaddingSmall),
            Expanded(
              flex: 1,
              child: Column(
                children: listAfternoon,
              ),
            ),
            const SizedBox(width: itemPaddingSmall),
            Expanded(
              flex: 1,
              child: Column(
                children: listEvening,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
