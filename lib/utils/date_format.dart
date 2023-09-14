import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate({required String date, String dateFormat = 'MMMM d, y', String locate = 'en_US'}) {
  DateTime newDate = DateTime.parse(date);
  return DateFormat(dateFormat, locate).format(newDate);
}

bool compareSpaceDate({required String date, int space = 30}) {
  DateTime newDateNow = DateTime.now();
  DateTime newDate = DateTime.parse(date).add(Duration(days: space));
  return !newDateNow.isAfter(newDate);
}

String? formatPosition({Duration? position}) {
  return RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch(position.toString())?.group(1);
}

String getLocate(BuildContext context) {
  final Locale appLocale = Localizations.localeOf(context);
  return appLocale.toString();
}