import 'dart:math';

import 'package:flutter/material.dart';
import 'package:woo_booking/model/record.dart';
import 'package:woo_booking/widget/time_stamp_item.dart';

class ListTimeStamp extends StatelessWidget {
  const ListTimeStamp({
    Key? key,
    required this.timeStamps,
    required this.onPickTimeStamp,
    required this.pickedTime,
  }) : super(key: key);
  final List<RecordBooking> timeStamps;
  final Function(DateTime? time) onPickTimeStamp;
  final DateTime pickedTime;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    int maxItem = 0;
    int numMor = 0;
    int numAf = 0;
    int numEv = 0;
    if (timeStamps.isNotEmpty && timeStamps.length > 1) {
      List<Widget> listMorning = [
        Text("Morning", style: theme.textTheme.bodyMedium),
        ...List.generate(timeStamps.length, (index) {
          if (timeStamps[index].date!.hour >= 0 && timeStamps[index].date!.hour < 12) {
            numMor++;
            return TimeStampItem(
              record: timeStamps[index],
              pickedTime: pickedTime,
              onPickTimeStamp: (time) {
                onPickTimeStamp(time);
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        }).toList()
      ];
      List<Widget> listAfternoon = [
        Text("Afternoon", style: theme.textTheme.bodyMedium),
        ...List.generate(timeStamps.length, (index) {
          if (timeStamps[index].date!.hour >= 12 && timeStamps[index].date!.hour < 17) {
            numAf++;
            return TimeStampItem(
              record: timeStamps[index],
              pickedTime: pickedTime,
              onPickTimeStamp: (time) {
                onPickTimeStamp(time);
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        }).toList()
      ];
      List<Widget> listEvening = [
        Text("Evening", style: theme.textTheme.bodyMedium),
        ...List.generate(timeStamps.length, (index) {
          if (timeStamps[index].date!.hour >= 17 && timeStamps[index].date!.hour < 24) {
            numEv++;
            return TimeStampItem(
              record: timeStamps[index],
              pickedTime: pickedTime,
              onPickTimeStamp: (time) {
                onPickTimeStamp(time);
              },
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
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: Column(
                children: listAfternoon,
              ),
            ),
            const SizedBox(width: 12),
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
