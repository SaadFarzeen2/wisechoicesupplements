import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:woo_booking/model/record.dart';
import 'package:woo_booking/widget/counter.dart';
import 'package:woo_booking/widget/dropdown_booking.dart';

class CustomDurationBooking extends StatefulWidget {
  const CustomDurationBooking({
    Key? key,
    required this.timeStamps,
    required this.maxDuration,
    required this.minDuration,
    required this.defaultDateAvailable,
    required this.durationUnit,
    required this.duration,
    required this.onPickEndTime,
    required this.onChangedCustomDuration,
  }) : super(key: key);
  final List<RecordBooking> timeStamps;
  final int minDuration;
  final int maxDuration;
  final bool defaultDateAvailable;
  final String durationUnit;
  final int duration;

  /// Enable for case duration unit is minute or hour.
  final Function(DateTime? startDate, int? fieldDuration) onPickEndTime;

  /// Enable for case duration unit is day or week or month.
  final Function(int value) onChangedCustomDuration;

  @override
  State<CustomDurationBooking> createState() => _CustomDurationBookingState();
}

class _CustomDurationBookingState extends State<CustomDurationBooking> {
  final List<RecordBooking> _endTimes = [];
  final ValueNotifier<bool> _loadingEndTime = ValueNotifier(false);
  DateTime? _startTime;
  RecordBooking defaultRecord = RecordBooking();

  @override
  Widget build(BuildContext context) {
    if (widget.durationUnit != 'hour' && widget.durationUnit != 'minute') {
      return CounterBooking(
        minValue: widget.minDuration,
        maxValue: widget.maxDuration,
        onChangedValue: widget.onChangedCustomDuration,
        durationUnit: widget.durationUnit,
        duration: widget.duration,
      );
    }
    if (widget.timeStamps.isNotEmpty) {
      return Row(
        children: [
          // Start time.
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Starts"),
                DropdownBooking(
                  items: [defaultRecord, ...widget.timeStamps],
                  onChanged: (value) async {
                    _loadingEndTime.value = true;
                    _startTime = value.date;
                    if (value.date != null) {
                      await Future.delayed(const Duration(milliseconds: 500));
                      _filterEndTimes();
                      widget.onPickEndTime(null, null);
                    }
                    _loadingEndTime.value = false;
                  },
                  dropBookingKey: DropBookingKey.start,
                ),
              ],
            ),
          ),
          // End time.
          Expanded(
              child: ValueListenableBuilder<bool>(
                  valueListenable: _loadingEndTime,
                  builder: (context, loading, _) {
                    if (loading) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    List<RecordBooking> items = [defaultRecord, ..._endTimes];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Ends"),
                        (_startTime == null || _endTimes.isEmpty)
                            ? const Text(
                                "Chose a start time.",
                                maxLines: 2,
                              )
                            : DropdownBooking(
                                items: items,
                                onChanged: (value) {
                                  if (_startTime != null &&
                                      value.fieldDuration != null) {
                                    widget.onPickEndTime(
                                      _startTime!,
                                      value.fieldDuration!,
                                    );
                                  } else {
                                    debugPrint(
                                        "Null at onChanged end time drop booking.");
                                  }
                                },
                                dropBookingKey: DropBookingKey.end,
                                durationUnit: widget.durationUnit,
                                duration: widget.duration,
                              ),
                      ],
                    );
                  }))
        ],
      );
    }
    return const Center(
      child: Text("Choose a date above to see available times."),
    );
  }

  /// Create list of end time from start time.
  void _filterEndTimes() {
    _endTimes.clear();
    DateTime? time;
    for (int index = (widget.minDuration == 0) ? 1 : widget.minDuration;
        index <= widget.maxDuration;
        index++) {
      if (_startTime != null) {
        time = _startTime!.add(
          Duration(
            minutes:
                (widget.durationUnit == 'minute') ? index * widget.duration : 0,
            hours:
                (widget.durationUnit == 'hour') ? index * widget.duration : 0,
          ),
        );
      }
      if (time != null) {
        if (widget.defaultDateAvailable) {
          _endTimes.add(RecordBooking(date: time, fieldDuration: index));
          // Subtract for case: start at 24h of the day before and end at 24 of the day after.
        } else if (isSameDay(
            _startTime, time.subtract(const Duration(seconds: 30)))) {
          _endTimes.add(RecordBooking(date: time, fieldDuration: index));
        }
        time = null;
      }
    }
  }
}
