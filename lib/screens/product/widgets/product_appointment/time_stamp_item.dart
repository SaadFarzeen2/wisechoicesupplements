import 'package:cirilla/models/product/staff_model.dart';
import 'package:cirilla/screens/product/widgets/product_appointment/appointment_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeStampItem extends StatefulWidget {
  const TimeStampItem({
    Key? key,
    required this.dateTime,
    this.pickedTime,
    required this.onPickTimeStamp,
    required this.scheduleTimes,
    required this.activeHoursData,
    required this.staffId,
    required this.staffs,
  }) : super(key: key);
  final List<DateTime> scheduleTimes;
  final Map<String, dynamic>? activeHoursData;
  final DateTime dateTime;
  final String? staffId;
  final DateTime? pickedTime;
  final Function(DateTime? time) onPickTimeStamp;
  final List<StaffModel> staffs;

  @override
  State<TimeStampItem> createState() => _TimeStampItemState();
}

class _TimeStampItemState extends State<TimeStampItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (widget.scheduleTimes.contains(widget.dateTime) &&
        calAvailableSlot(activeHoursData: widget.activeHoursData, date: widget.dateTime, staffId: widget.staffId) < 1) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            widget.onPickTimeStamp(widget.dateTime);
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
                DateFormat('hh:mm a').format(widget.dateTime),
              ),
              if (widget.scheduleTimes.contains(widget.dateTime))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (getMaxAvailable(
                                activeHoursData: widget.activeHoursData,
                                date: widget.dateTime,
                                staffs: widget.staffs,
                                staffId: widget.staffId) >
                            0)
                        ? Text("${getMaxAvailable(
                            activeHoursData: widget.activeHoursData,
                            date: widget.dateTime,
                            staffId: widget.staffId,
                            staffs: widget.staffs,
                          )} max")
                        : const SizedBox.shrink(),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                        "${calAvailableSlot(activeHoursData: widget.activeHoursData, date: widget.dateTime, staffId: widget.staffId).toString()} left"),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  _isPicked() {
    if (widget.pickedTime != null) {
      if (widget.pickedTime == DateTime(1999)) {
        return false;
      }
      return (widget.dateTime.hour == widget.pickedTime!.hour && widget.dateTime.minute == widget.pickedTime!.minute);
    }
    return false;
  }
}
