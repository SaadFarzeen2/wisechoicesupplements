import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:woo_booking/helper.dart';

class MonthsAvailableBooking extends StatefulWidget {
  const MonthsAvailableBooking({
    Key? key,
    required this.months,
    required this.onTap,
    required this.pickedTime,
  }) : super(key: key);
  final List<DateTime> months;
  final Function(DateTime) onTap;
  final ValueNotifier<DateTime> pickedTime;

  @override
  State<MonthsAvailableBooking> createState() => _MonthsAvailableBookingState();
}

class _MonthsAvailableBookingState extends State<MonthsAvailableBooking> {
  late double height;
  @override
  void initState() {
    _countHeight();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MonthsAvailableBooking oldWidget) {
    _countHeight();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ValueListenableBuilder<DateTime>(
        valueListenable: widget.pickedTime,
        builder: (context, pickedTime, _) {
          return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2,
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: List.generate(
                widget.months.length,
                (index) => InkWell(
                      onTap: () {
                        widget.onTap(widget.months[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: (isSameMonth(pickedTime, widget.months[index])
                              ? Colors.black
                              : Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            DateFormat('MMM yyyy').format(widget.months[index]),
                            style: TextStyle(
                              color:
                                  (isSameMonth(pickedTime, widget.months[index])
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    )).toList(),
          );
        },
      ),
    );
  }

  void _countHeight() {
    if (widget.months.length % 3 > 0) {
      height = 30 + 75.0 * ((widget.months.length ~/ 3) + 1);
    } else {
      height = 30 + 75.0 * (widget.months.length ~/ 3);
    }
  }
}
