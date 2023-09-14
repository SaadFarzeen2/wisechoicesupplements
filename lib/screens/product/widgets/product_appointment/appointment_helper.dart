import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/staff_model.dart';
import 'package:flutter/cupertino.dart';

bool activeDayAppointment(
    {required DateTime day,
    required String durationUnit,
    required List<DateTime> activeHours,
    required Map<String, dynamic> restrictedDays,
    required bool hasRestrictedDay,
    required int duration}) {
  if (DateTime.now().day == day.day &&
      DateTime.now().month == day.month &&
      DateTime.now().year == day.year) {
    if (activeHours
        .where((element) =>
            element.day == day.day &&
            element.month == day.month &&
            element.year == day.year &&
            element.isAfter(DateTime.now()))
        .isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
  if (durationUnit != "day") {
    return (hasRestrictedDay)
        ? !(activeHours.firstWhere(
                (element) => (element.day == day.day &&
                    element.month == day.month &&
                    element.year == day.year &&
                    get(restrictedDays, [day.weekday.toString()], null) !=
                        null),
                orElse: () => DateTime(1999)) ==
            DateTime(1999))
        : !(activeHours.firstWhere(
                (element) => (element.day == day.day &&
                    element.month == day.month &&
                    element.year == day.year),
                orElse: () => DateTime(1999)) ==
            DateTime(1999));
  } else {
    List<int> endOfRange = [0];
    for (int index = 0; index < activeHours.length - 1; index++) {
      if ((activeHours[index + 1].difference(activeHours[index])).inHours >
          24) {
        endOfRange.add(index + 1);
      }
    }
    List<DateTime> listActive = [];
    endOfRange.add(activeHours.length);
    for (int index = 0; index < endOfRange.length - 1; index++) {
      List<DateTime> listTmp = [];
      listTmp = activeHours.sublist(endOfRange[index], endOfRange[index + 1]);
      if (duration < listTmp.length) {
        listActive.addAll(listTmp.sublist(0, listTmp.length - duration + 1));
      }
    }
    return (hasRestrictedDay)
        ? !(listActive.firstWhere(
                (element) => (element.day == day.day &&
                    element.month == day.month &&
                    element.year == day.year &&
                    get(restrictedDays, [day.weekday.toString()], null) !=
                        null),
                orElse: () => DateTime(1999)) ==
            DateTime(1999))
        : !(listActive.firstWhere(
                (element) => (element.day == day.day &&
                    element.month == day.month &&
                    element.year == day.year),
                orElse: () => DateTime(1999)) ==
            DateTime(1999));
  }
}

List<DateTime> mapActiveHoursToStaff(
    {required String? staffId,
    required List<DateTime> defaultValue,
    required DateTime? selectedDay,
    required ValueNotifier<DateTime> pickedTime,
    Map<String, dynamic>? activeHoursData}) {
  List<DateTime> res = [];
  if (staffId == null) {
    return defaultValue;
  }
  if (activeHoursData != null) {
    if (activeHoursData["records"] != null) {
      res.clear();
      for (dynamic record in activeHoursData["records"]) {
        if (record["date"] != null) {
          if (DateTime.tryParse(record["date"]) != null) {
            if (record["staff_id"].toString() == staffId) {
              res.add(DateTime.tryParse(record["date"])!);
            }
          }
        }
      }
    }
  }
  if (selectedDay != null) {
    res = res
        .where(
          (element) => (element.day == selectedDay.day &&
              element.month == selectedDay.month &&
              element.year == selectedDay.year),
        )
        .toList();
    return res;
  } else {
    if (pickedTime.value != DateTime(1999)) {
      res = res
          .where(
            (element) => (element.day == pickedTime.value.day &&
                element.month == pickedTime.value.month &&
                element.year == pickedTime.value.year),
          )
          .toList();
      return res;
    }
    return [];
  }
}

List<DateTime> getScheduledTime({
  required Map<String, dynamic>? activeHoursData,
  required int maxQuantity,
  required String? staffId,
}) {
  List<DateTime> scheduledTimes = [];
  if (staffId != null) {
    if (activeHoursData?["records"] != null) {
      for (dynamic record in activeHoursData!["records"]) {
        if (record["date"] != null) {
          if (DateTime.tryParse(record["date"]) != null) {
            DateTime dateTmp = DateTime.tryParse(record["date"])!;
            if (record["available"] != null) {
              if (record["available"] < maxQuantity) {
                if (staffId == get(record, ["staff_id"], -1).toString()) {
                  scheduledTimes.add(dateTmp);
                }
              }
            }
          }
        }
      }
    }
  } else {
    if (activeHoursData?["records"] != null) {
      for (dynamic record in activeHoursData!["records"]) {
        if (record["date"] != null) {
          if (DateTime.tryParse(record["date"]) != null) {
            DateTime dateTmp = DateTime.tryParse(record["date"])!;
            if (record["available"] != null) {
              if (record["available"] < maxQuantity) {
                scheduledTimes.add(dateTmp);
              }
            }
          }
        }
      }
    }
  }
  return scheduledTimes;
}

bool isScheduledDay({
  required List<DateTime> scheduleTimes,
  required DateTime date,
}) {
  for (DateTime time in scheduleTimes) {
    if (time.year == date.year &&
        time.month == date.month &&
        time.day == date.day &&
        date.isAfter(DateTime.now())) {
      return true;
    }
  }
  return false;
}

int calAvailableSlot({
  required Map<String, dynamic>? activeHoursData,
  required DateTime date,
  required String? staffId,
}) {
  int availableSlots = 0;
  if (staffId != null) {
    if (activeHoursData != null) {
      for (dynamic record in activeHoursData["records"]) {
        if (record["date"] != null) {
          if (DateTime.tryParse(record["date"]) != null) {
            DateTime dateTmp = DateTime.tryParse(record["date"])!;
            if (dateTmp.isAtSameMomentAs(date)) {
              if (record["available"] != null) {
                if (get(record, ["staff_id"], -1).toString() == staffId) {
                  availableSlots = record["available"];
                }
              }
            }
          }
        }
      }
    }
  } else {
    if (activeHoursData != null) {
      for (dynamic record in activeHoursData["records"]) {
        if (record["date"] != null) {
          if (DateTime.tryParse(record["date"]) != null) {
            DateTime dateTmp = DateTime.tryParse(record["date"])!;
            if (dateTmp.isAtSameMomentAs(date)) {
              if (record["available"] != null) {
                int slot = record!["available"];
                availableSlots += slot;
              }
            }
          }
        }
      }
    }
  }
  return availableSlots;
}

int getMaxAvailable({
  required Map<String, dynamic>? activeHoursData,
  required DateTime date,
  required String? staffId,
  required List<StaffModel> staffs,
}) {
  int max = 0;
  if (staffs.where((element) => element.id != null).isEmpty) {
    return max;
  }
  if (staffId == null) {
    if (activeHoursData != null) {
      for (dynamic record in activeHoursData["records"]) {
        if (record["date"] != null) {
          if (DateTime.tryParse(record["date"]) != null) {
            DateTime dateTmp = DateTime.tryParse(record["date"])!;
            if (dateTmp.isAtSameMomentAs(date)) {
              if (record["available"] != null) {
                if (max < record["available"]) {
                  max = record["available"];
                }
              }
            }
          }
        }
      }
    }
  }
  return max;
}
