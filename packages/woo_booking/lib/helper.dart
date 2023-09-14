import 'package:table_calendar/table_calendar.dart';

/// Filter date is enable or disable.
///
bool activeDayAppointment({
  required DateTime day,
  required Map<String, dynamic> bookableData,

  /// The [defaultDateAvailable] is All dates are... field in plugin setting.
  required bool defaultDateAvailable,
  required String minDateUnit,
  required int minDateValue,
  required String maxDateUnit,
  required int maxDateValue,
  required DateTime now,
  required List<String> restrictedDays,
  required bool hasRestrictedDay,
}) {
  if (defaultDateAvailable) {
    if (isSameDay(day, now) || day.isAfter(now)) {
      DateTime minTime = now;
      if (minDateValue > 0) {
        switch (minDateUnit) {
          case "day":
            minTime = now.add(Duration(days: minDateValue));
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          case "week":
            minTime = now.add(Duration(days: minDateValue * 7));
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          case "month":
            minTime = getNextMonth(minDateValue, now);
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          default:
            break;
        }
      }
      if (maxDateValue > 0) {
        DateTime maxTime = now;
        switch (maxDateUnit) {
          case "day":
            maxTime = now.add(Duration(days: maxDateValue));
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          case "week":
            maxTime = now.add(Duration(days: maxDateValue * 7));
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          case "month":
            maxTime = getNextMonth(maxDateValue, now);
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          default:
            break;
        }
      }
      if (hasRestrictedDay && restrictedDays.isNotEmpty) {
        return _checkRestrictedDay(day, restrictedDays);
      }
      return true;
    }
    return false;
  } else {
    List<dynamic> availabilityRules =
        (get(bookableData, ['availability_rules'], []) as List<dynamic>).first;
    bool bookable = false;
    if (availabilityRules.isNotEmpty) {
      DateTime minTime = now;
      if (minDateValue > 0) {
        switch (minDateUnit) {
          case "day":
            minTime = now.add(Duration(days: minDateValue));
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          case "week":
            minTime = now.add(Duration(days: minDateValue * 7));
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          case "month":
            minTime = getNextMonth(minDateValue, now);
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          default:
            break;
        }
      }
      if (maxDateValue > 0) {
        DateTime maxTime = now;
        switch (maxDateUnit) {
          case "day":
            maxTime = now.add(Duration(days: maxDateValue));
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          case "week":
            maxTime = now.add(Duration(days: maxDateValue * 7));
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          case "month":
            maxTime = getNextMonth(maxDateValue, now);
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          default:
            break;
        }
      }
      bookable = get(
          availabilityRules.first,
          [
            'range',
            (day.year.toString()),
            (day.month.toString()),
            (day.day.toString())
          ],
          false);
    }
    if (bookable) {
      if (hasRestrictedDay && restrictedDays.isNotEmpty) {
        return _checkRestrictedDay(day, restrictedDays);
      }
      return bookable;
    }
    return bookable;
  }
}

_checkRestrictedDay(
  DateTime date,
  List<String> restrictedDays,
) {
  List<String> days = restrictedDays;
  // Value 7 is Sunday.
  if (days.contains("0")) {
    days.add("7");
  }
  if (days.contains(date.weekday.toString())) {
    return true;
  }
  return false;
}

/// Get the next month.
///
/// Problem: If the day of current month is not in before month
/// (Ex: current is 2022/01/30, result will be 2022/03/02).
///
/// But not affect booking function.
DateTime getNextMonth(int addTime, DateTime now) {
  int year = now.year;
  int month = (now.month + addTime) % 12;
  int added = (now.month + addTime) ~/ 12;
  if (month != 0) {
    if (added > 0) {
      return DateTime(year + added, month, now.day);
    } else {
      return DateTime(year, month, now.day);
    }
  } else {
    year = year + (added - 1);
    if (added > 1) {
      return DateTime(year, now.month, now.day);
    } else {
      return DateTime(year, now.month + addTime, now.day);
    }
  }
}

/// Get the before month.
///
DateTime getBeforeMonth(int subTime, DateTime now) {
  if (now.month > subTime) {
    return DateTime(now.year, now.month - subTime);
  } else {
    if (subTime < 12) {
      return DateTime(now.year - 1, 12 + (now.month - subTime));
    } else {
      return getBeforeMonth(
          subTime % 12, DateTime(now.year - (subTime ~/ 12), now.month));
    }
  }
}

/// Get available custom months
///
List<DateTime> getCustomMonthsAvailable(DateTime start, DateTime end) {
  List<DateTime> result = [];
  DateTime startTime = start;
  DateTime endTime = end;
  // If isn't first day of the month, remove this month.
  if (start.day != 1) {
    startTime = getNextMonth(1, start);
  }
  // If day of end is not last day of the month, remove this month.
  if (end.month == end.add(const Duration(days: 1)).month) {
    endTime = getBeforeMonth(1, end);
  }

  if (endTime.year == startTime.year && endTime.month == startTime.month) {
    result.add(startTime);
  } else {
    int monthDif = endTime.month - startTime.month;
    int yearDif = endTime.year - startTime.year;
    if (yearDif == 0) {
      for (int i = 0; i <= monthDif; i++) {
        result.add(getNextMonth(i, startTime));
      }
    } else {
      int totalMonth = yearDif * 12 + monthDif;
      for (int i = 0; i <= totalMonth; i++) {
        result.add(getNextMonth(i, startTime));
      }
    }
  }
  return result;
}

dynamic get(dynamic data, List<dynamic> paths, [defaultValue]) {
  if (data == null || (paths.isNotEmpty && !(data is Map || data is List))) {
    return defaultValue;
  }
  if (paths.isEmpty) return data ?? defaultValue;
  List<dynamic> newPaths = List.of(paths);
  String? key = newPaths.removeAt(0);
  return get(data[key], newPaths, defaultValue);
}

/// Convert String to int
int stringToInt([dynamic value = '0', int initValue = 0]) {
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? initValue;
  }
  return initValue;
}

double stringToDouble(dynamic value, [double defaultValue = 0]) {
  if (value == null || value == "") {
    return defaultValue;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is double) {
    return value;
  }

  if (value is String) {
    return double.tryParse(value) ?? defaultValue;
  }

  return defaultValue;
}

bool isSameMonth(DateTime a, DateTime b) {
  return (a.year == b.year && a.month == b.month);
}

DateTime getFutureDate(DateTime time, String unit, int addedValue) {
  DateTime result = time;
  switch (unit) {
    case 'month':
      result = getNextMonth(addedValue, time);
      return result;
    case 'week':
      result = time.add(Duration(days: 7 * addedValue));
      return result;
    case 'day':
      result = time.add(Duration(days: addedValue));
      return result;
    case 'hour':
      result = time.add(Duration(hours: addedValue));
      return result;
    default:
      return result;
  }
}
