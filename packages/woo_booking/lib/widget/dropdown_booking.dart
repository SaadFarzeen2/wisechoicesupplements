import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:woo_booking/model/record.dart';

enum DropBookingKey { start, end }

class DropdownBooking extends StatefulWidget {
  const DropdownBooking({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.dropBookingKey,
    this.durationUnit,
    this.duration,
  }) : super(key: key);
  final List<RecordBooking> items;
  final Function(RecordBooking record) onChanged;
  final DropBookingKey dropBookingKey;
  final String? durationUnit;
  final int? duration;
  @override
  State<DropdownBooking> createState() => _DropdownBookingState();
}

class _DropdownBookingState extends State<DropdownBooking> {
  late RecordBooking _currentValue;

  @override
  void initState() {
    _currentValue = widget.items.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: DropdownButton<RecordBooking>(
        value: _currentValue,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        menuMaxHeight: 500,
        borderRadius: BorderRadius.circular(10),
        alignment: Alignment.center,
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        onChanged: (RecordBooking? value) {
          if (value != null) {
            widget.onChanged(value);
            setState(() {
              _currentValue = value;
            });
          }
        },
        items: widget.items
            .map<DropdownMenuItem<RecordBooking>>((RecordBooking value) {
          return DropdownMenuItem<RecordBooking>(
            value: value,
            child: Text(
              _getText(value),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getText(RecordBooking record) {
    String text = '';
    if (widget.dropBookingKey == DropBookingKey.start) {
      if (record.date != null) {
        text = DateFormat('hh:mm a').format(record.date!);
        if (record.available != null &&
            record.booked != null &&
            record.available! > 0 &&
            record.booked! > 0) {
          text += " (${NumberFormat.compact().format(record.available)} left)";
        }
      } else {
        text = "Start time";
      }
    } else {
      if (record.date != null) {
        text = DateFormat('hh:mm a').format(record.date!);
        if (widget.duration != null &&
            widget.durationUnit != null &&
            record.fieldDuration != null) {
          text +=
              " (${widget.duration! * record.fieldDuration!} ${widget.durationUnit}s)";
        }
      } else {
        text = "End time";
      }
    }
    return text;
  }
}
