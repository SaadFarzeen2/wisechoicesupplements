import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:woo_booking/product_booking.dart';
import 'package:woo_booking/widget/calendar_header.dart';

class DefaultCalendar extends StatelessWidget {
  const DefaultCalendar({
    Key? key,
    this.error,
    this.onTapRetry,
  }) : super(key: key);
  final bool? error;
  final Function()? onTapRetry;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Style.
    TextStyle defaultTextCalendar = theme.textTheme.titleSmall ?? const TextStyle();
    TextStyle disableTextCalendar = theme.textTheme.bodyMedium ?? const TextStyle();
    return Stack(
      children: [
        SizedBox(
          height: 400,
          child: Column(
            children: [
              CalendarHeader(
                focusedDay: nowBookingTime,
                onRightArrowTap: () {},
              ),
              TableCalendar(
                availableGestures: AvailableGestures.none,
                firstDay: nowBookingTime,
                lastDay: (nowBookingTime.add(const Duration(days: 3650))),
                focusedDay: nowBookingTime,
                headerVisible: false,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  defaultTextStyle: defaultTextCalendar,
                  todayTextStyle: defaultTextCalendar.copyWith(color: Colors.red),
                  disabledTextStyle: disableTextCalendar,
                  selectedTextStyle: defaultTextCalendar.copyWith(color: theme.colorScheme.onPrimary),
                  weekendTextStyle: defaultTextCalendar,
                  todayDecoration: const BoxDecoration(),
                  selectedDecoration: BoxDecoration(color: theme.primaryColor, shape: BoxShape.circle),
                  markerDecoration: BoxDecoration(
                    color: theme.textTheme.bodySmall?.color,
                    shape: BoxShape.circle,
                  ),
                  markersAnchor: 1.3,
                ),
                daysOfWeekHeight: 21,
                eventLoader: (day) {
                  return [];
                },
              ),
            ],
          ),
        ),
        if (error != null)
          Container(
            color: Colors.white.withOpacity(0.3),
            height: 400,
            child: Column(
              children: [
                const Text("Loading error."),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    if (onTapRetry != null) {
                      onTapRetry!();
                    }
                  },
                  child: const Text(
                    "Retry",
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          )
      ],
    );
  }
}
