import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:woo_booking/model/record.dart';
import 'package:woo_booking/product_booking.dart';

class TimeStampItem extends StatefulWidget {
  const TimeStampItem({
    Key? key,
    required this.record,
    required this.pickedTime,
    required this.onPickTimeStamp,
  }) : super(key: key);
  final RecordBooking record;
  final DateTime pickedTime;
  final Function(DateTime? time) onPickTimeStamp;

  @override
  State<TimeStampItem> createState() => _TimeStampItemState();
}

class _TimeStampItemState extends State<TimeStampItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            widget.onPickTimeStamp(widget.record.date!);
          },
          style: TextButton.styleFrom(
            foregroundColor: _isPicked() ? theme.colorScheme.onPrimary : theme.textTheme.titleMedium?.color,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 50),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: _isPicked() ? theme.primaryColor : Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: _isPicked() ? theme.primaryColor : theme.dividerColor),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat('hh:mm a').format(widget.record.date!),
              ),
              if (widget.record.available != null &&
                  widget.record.booked != null &&
                  widget.record.available! > 0 &&
                  widget.record.booked! > 0)
                Text("(${NumberFormat.compact().format(widget.record.available)} left)")
            ],
          ),
        ),
      ),
    );
  }

  _isPicked() {
    if (widget.pickedTime == defaultTime) {
      return false;
    }
    return (widget.record.date!.hour == widget.pickedTime.hour &&
        widget.record.date!.minute == widget.pickedTime.minute);
  }
}
