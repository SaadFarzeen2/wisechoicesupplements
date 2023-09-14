import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/staff_model.dart';
import 'package:cirilla/screens/product/widgets/product_appointment/appointment_helper.dart';
import 'package:cirilla/screens/product/widgets/product_appointment/calendar_header.dart';
import 'package:cirilla/screens/product/widgets/product_appointment/list_time_stamp.dart';
import 'package:cirilla/screens/product/widgets/product_appointment/menu_staff.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:collection/collection.dart';

class ProductAppointment extends StatefulWidget {
  final Map<String, dynamic>? appointment;
  final Function(Map<String, dynamic>)? onChanged;
  final String productId;

  const ProductAppointment({
    Key? key,
    this.appointment,
    this.onChanged,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductAppointment> createState() => _ProductAppointmentState();
}

class _ProductAppointmentState extends State<ProductAppointment> with Utility {
  PageController _pageController = PageController();
  late RequestHelper _requestHelper;

  Map<String, dynamic>? _activeHoursData = {};
  Map<String, dynamic> _restrictedDays = {};

  List<DateTime> _allActiveTimeStamps = [];
  List<StaffModel> _listStaff = [];
  final List<DateTime> _activeHours = [];
  String _listStaffId = "";
  String staffLabel = "";
  String _durationUnit = "hour";
  int _duration = 0;
  int _qty = 0;
  bool _availabilityAutoSelect = false;
  bool enableHeadingLeftArrow = false;
  String _hasRestrictedDays = "";

  final ValueNotifier<List<DateTime>> _timeStamps = ValueNotifier([]);
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final ValueNotifier<DateTime> _pickedTime = ValueNotifier(DateTime(1999));
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<StaffModel> _pickedStaff = ValueNotifier(StaffModel(name: "No Preference"));

  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime endDate = DateTime((DateTime.now().month >= 11) ? DateTime.now().year + 1 : DateTime.now().year,
      (DateTime.now().month >= 11) ? (DateTime.now().month % 10) : DateTime.now().month + 2);
  DateTime? _selectedDay;

  //-------------------Get data------------------------//
  Future<void> _getActiveData() async {
    try {
      _loading.value = true;
      var data = await _requestHelper.getActiveHours(
        queryParameters: {
          "product_ids": widget.productId,
          "min_date": DateFormat("yyyy-MM-dd").format(startDate),
          "max_date": DateFormat("yyyy-MM-dd").format(endDate)
        },
      );
      _loading.value = false;
      setState(() {
        _activeHoursData = data;
      });
    } catch (_) {
      _loading.value = false;
    }
  }

  Future<dynamic> _getSlotsData({required bool availabilityAutoSelect}) async {
    List records = [];
    dynamic data;
    if (availabilityAutoSelect) {
      await Future.doWhile(() async {
        try {
          data = await _requestHelper.getActiveHours(
            queryParameters: {
              "product_ids": widget.productId,
              "min_date": DateFormat("yyyy-MM-dd").format(startDate),
              "max_date": DateFormat("yyyy-MM-dd").format(endDate)
            },
          );
          if (data["records"] != null) {
            if (data["records"] is List) {
              records = data["records"];
              if (records.isEmpty) {
                endDate = DateTime((endDate.month == 12) ? (endDate.year + 1) : endDate.year,
                    (endDate.month == 12) ? (1) : endDate.month + 1);
              }
            }
          }
        } catch (_) {}
        return (records.isEmpty && !endDate.isAfter(DateTime.now().add(const Duration(days: 730))));
      });
    } else {
      try {
        data = await _requestHelper.getActiveHours(
          queryParameters: {
            "product_ids": widget.productId,
            "min_date": DateFormat("yyyy-MM-dd").format(startDate),
            "max_date": DateFormat("yyyy-MM-dd").format(endDate)
          },
        );
      } catch (_) {}
    }
    return data;
  }

  Future<void> _getAppointmentData() async {
    try {
      _loading.value = true;
      var product = await _requestHelper.getAppointmentProduct(productId: widget.productId);
      String staffAssignment = get(product, ['staff_assignment'], 'customer');

      staffLabel = get(product, ['staff_label'], '');
      _durationUnit = get(product, ['duration_unit'], 'hour');
      _duration = ConvertData.stringToInt(get(product, ['duration'], 0));
      _availabilityAutoSelect = get(product, ['availability_autoselect'], false);
      _hasRestrictedDays = get(product, ['has_restricted_days'], "");
      dynamic restricted = get(product, ['restricted_days'], {});
      if (restricted is! String) {
        _restrictedDays = get(product, ['restricted_days'], {});
      }
      List staffIds = get(product, ['staff_ids'], []) is List ? get(product, ['staff_ids'], []) : [];

      dynamic data = await _getSlotsData(availabilityAutoSelect: _availabilityAutoSelect);

      if (_availabilityAutoSelect) {
        DateTime? firstActiveTime;
        if (data["records"] != null) {
          for (dynamic record in data["records"]) {
            if (record["date"] != null) {
              if (DateTime.tryParse(record["date"]) != null) {
                firstActiveTime = DateTime.tryParse(record["date"]);
                break;
              }
            }
          }
        }
        if (firstActiveTime != null) {
          _focusedDay.value = firstActiveTime;
          _selectedDay = firstActiveTime;
          _pickedTime.value = firstActiveTime;
          List<DateTime> listTmp = [];
          if (data["records"] != null) {
            for (dynamic record in data["records"]) {
              if (record["date"] != null) {
                if (DateTime.tryParse(record["date"]) != null) {
                  DateTime dateTmp = DateTime.tryParse(record["date"])!;
                  if (dateTmp.day == _selectedDay?.day &&
                      dateTmp.month == _selectedDay?.month &&
                      dateTmp.year == _selectedDay?.year) {
                    if (!listTmp.contains(dateTmp)) {
                      listTmp.add(dateTmp);
                    }
                  }
                }
              }
            }
          }
          _timeStamps.value = listTmp;
          widget.onChanged?.call({
            ...?widget.appointment,
            'date': DateFormat("yyyy-MM-dd").format(firstActiveTime),
            'time': DateFormat("HH:mm").format(firstActiveTime),
            'staff_id': _pickedStaff.value.id,
            'staff_name': _pickedStaff.value.name,
          });
        }
      }

      try {
        if (staffAssignment == 'customer') {
          bool staffNopref = get(product, ['staff_nopref'], false);
          for (int id in staffIds) {
            _listStaffId = "$_listStaffId$id,";
          }

          List staffs = await _requestHelper.getStaffs(
            queryParameters: {
              "product_ids": widget.productId,
              "min_date": DateFormat("yyyy-MM-dd").format(startDate),
              "max_date": DateFormat("yyyy-MM-dd").format(endDate),
              "include": _listStaffId,
              "order": "asc",
              "orderby": "include",
            },
          );
          _listStaff.clear();
          if (staffs.isNotEmpty) {
            for (var staff in staffs) {
              String idStaff = '${get(staff, ['id'], '')}';
              String nameStaff = get(staff, ['display_name'], '');
              List products = get(staff, ['products'], []);
              dynamic productStaff =
                  products.firstWhereOrNull((element) => '${get(element, ['id'], '')}' == widget.productId);

              double price = ConvertData.stringToDouble(get(productStaff, ['staff_cost'], ''));
              if (products.firstWhereOrNull((element) => '${get(element, ['id'], '')}' == widget.productId) != null) {
                _listStaff.add(StaffModel(id: idStaff, name: nameStaff, price: price));
              }
            }
            if (staffNopref) {
              if (mounted) {}
              _listStaff = [
                StaffModel(name: AppLocalizations.of(context)!.translate('product_appointment_no_preference')),
                ..._listStaff
              ];
            }
          }
          if (_listStaff.isNotEmpty) {
            _pickedStaff.value = _listStaff.first;
          }
        }
      } catch (_) {}

      _loading.value = false;
      setState(() {
        _activeHoursData = data;
      });
    } catch (_) {
      _loading.value = false;
    }
  }
  //---------------------------------------------------//

  void init() async {
    await _getAppointmentData();
    String? date = get(widget.appointment, ["date"], null);
    String? time = get(widget.appointment, ["time"], null);
    String? staffId = get(widget.appointment, ["staff_id"], null);
    String? staffName = get(widget.appointment, ["staff_name"], null);
    if (time != null) {
      _selectedDay = DateFormat("yyyy-MM-dd-HH:mm").parse("$date-$time");
      List<DateTime> atvHours = [];
      if (_activeHoursData != null) {
        if (_activeHoursData!["records"] != null) {
          for (dynamic record in _activeHoursData!["records"]) {
            if (record["date"] != null) {
              if (DateTime.tryParse(record["date"]) != null) {
                if (!atvHours.contains(DateTime.tryParse(record["date"])!)) {
                  atvHours.add(DateTime.tryParse(record["date"])!);
                }
              }
            }
          }
        }
      }

      _timeStamps.value = atvHours
          .where(
            (element) => (element.day == _selectedDay?.day &&
                element.month == _selectedDay?.month &&
                element.year == _selectedDay?.year),
          )
          .toList();

      _pickedTime.value = DateFormat("yyyy-MM-dd-HH:mm").parse("$date-$time");

      _pickedStaff.value = StaffModel(name: staffName, id: staffId);
    }
  }

  @override
  void didChangeDependencies() {
    _requestHelper = Provider.of<SettingStore>(context).requestHelper;
    init();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _focusedDay.addListener(() {
      DateTime now = DateTime.now();
      DateTime nowMonth = DateTime(now.year, now.month);
      DateTime focusMonth = DateTime(_focusedDay.value.year, _focusedDay.value.month);

      setState(() {
        enableHeadingLeftArrow = focusMonth.compareTo(nowMonth) > 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (_activeHoursData != null) {
      if (_activeHoursData!["records"] != null) {
        _activeHours.clear();
        for (dynamic record in _activeHoursData!["records"]) {
          if (record["available"] != null) {
            if (_qty < record["available"]) {
              _qty = record["available"];
            }
          }
          if (record["date"] != null) {
            if (DateTime.tryParse(record["date"]) != null) {
              if (!_activeHours.contains(DateTime.tryParse(record["date"])!)) {
                _activeHours.add(DateTime.tryParse(record["date"])!);
              }
            }
          }
        }
      }
    }

    TextStyle defaultTextCalendar = theme.textTheme.titleSmall ?? const TextStyle();
    TextStyle disableTextCalendar = theme.textTheme.bodyMedium ?? const TextStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (_listStaff.isNotEmpty)
            ? ValueListenableBuilder<StaffModel>(
                valueListenable: _pickedStaff,
                builder: (context, value, _) {
                  return MenuStaff(
                    staffLabel: staffLabel,
                    onChange: (staff) {
                      if (staff != null) {
                        if (_selectedDay != null) {
                          _timeStamps.value = mapActiveHoursToStaff(
                              staffId: staff.id,
                              defaultValue: _allActiveTimeStamps,
                              selectedDay: _selectedDay,
                              pickedTime: _pickedTime,
                              activeHoursData: _activeHoursData);
                        }
                        _pickedStaff.value = staff;
                      }
                      if (_selectedDay != null) {
                        if (!_timeStamps.value.contains(_pickedTime.value)) {
                          _pickedTime.value = _timeStamps.value.first;
                          widget.onChanged?.call({
                            ...?widget.appointment,
                            'date': DateFormat("yyyy-MM-dd").format(_pickedTime.value),
                            'time': DateFormat("HH:mm").format(_pickedTime.value),
                            'staff_id': _pickedStaff.value.id,
                            'staff_name': _pickedStaff.value.name,
                          });
                        }
                      }
                    },
                    listStaff: _listStaff,
                    dropdownValue: value,
                  );
                })
            : const SizedBox.shrink(),
        Stack(
          children: [
            SizedBox(
              height: 400,
              child: Column(
                children: [
                  ValueListenableBuilder<DateTime>(
                    valueListenable: _focusedDay,
                    builder: (context, value, _) {
                      return CalendarHeader(
                        focusedDay: value,
                        onLeftArrowTap: enableHeadingLeftArrow
                            ? () async {
                                endDate = DateTime((endDate.month == 1) ? (endDate.year - 1) : endDate.year,
                                    (endDate.month == 1) ? (12) : endDate.month - 1);
                                await _getActiveData();
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 10),
                                  curve: Curves.easeOut,
                                );
                              }
                            : null,
                        onRightArrowTap: () async {
                          endDate = DateTime((endDate.month == 12) ? (endDate.year + 1) : endDate.year,
                              (endDate.month == 12) ? (1) : endDate.month + 1);
                          await _getActiveData();
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 10),
                            curve: Curves.easeOut,
                          );
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<StaffModel>(
                    valueListenable: _pickedStaff,
                    builder: (context, value, _) {
                      return TableCalendar(
                        onCalendarCreated: (controller) => _pageController = controller,
                        availableGestures: AvailableGestures.none,
                        firstDay: DateTime.now(),
                        lastDay: (DateTime.now().add(const Duration(days: 3650))),
                        focusedDay: _focusedDay.value,
                        headerVisible: false,
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          defaultTextStyle: defaultTextCalendar,
                          todayTextStyle: defaultTextCalendar.copyWith(color: ColorBlock.red),
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
                          if (!isScheduledDay(
                              date: day,
                              scheduleTimes: getScheduledTime(
                                  activeHoursData: _activeHoursData,
                                  maxQuantity: _qty,
                                  staffId: _pickedStaff.value.id))) {
                            return [];
                          }
                          return [""];
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay) &&
                              activeDayAppointment(
                                day: selectedDay,
                                activeHours: _activeHours,
                                duration: _duration,
                                durationUnit: _durationUnit,
                                hasRestrictedDay: (_hasRestrictedDays != ""),
                                restrictedDays: _restrictedDays,
                              )) {
                            List<DateTime> listActiveHours = _activeHours
                                .where(
                                  (element) => (element.day == selectedDay.day &&
                                      element.month == selectedDay.month &&
                                      element.year == selectedDay.year),
                                )
                                .toList();
                            _timeStamps.value = listActiveHours;
                            _allActiveTimeStamps = listActiveHours;
                            if (_pickedTime.value != DateTime(1999)) {
                              _pickedTime.value = DateTime(selectedDay.year, selectedDay.month, selectedDay.day,
                                  _pickedTime.value.hour, _pickedTime.value.minute);
                              widget.onChanged?.call({
                                ...?widget.appointment,
                                'date': DateFormat("yyyy-MM-dd").format(_pickedTime.value),
                                'time': DateFormat("HH:mm").format(_pickedTime.value),
                                'staff_id': _pickedStaff.value.id,
                                'staff_name': _pickedStaff.value.name,
                              });
                            }
                            if (mounted) {
                              _timeStamps.value = mapActiveHoursToStaff(
                                  staffId: _pickedStaff.value.id,
                                  defaultValue: _allActiveTimeStamps,
                                  selectedDay: selectedDay,
                                  pickedTime: _pickedTime,
                                  activeHoursData: _activeHoursData);
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay.value = focusedDay;
                              });
                            }
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay.value = focusedDay;
                        },
                        enabledDayPredicate: (date) {
                          return activeDayAppointment(
                              day: date,
                              activeHours: _activeHours,
                              duration: _duration,
                              durationUnit: _durationUnit,
                              hasRestrictedDay: (_hasRestrictedDays != ""),
                              restrictedDays: _restrictedDays);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<bool>(
                valueListenable: _loading,
                builder: (context, value, _) {
                  return (value)
                      ? Container(
                          height: 400,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        )
                      : const SizedBox.shrink();
                })
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Divider(thickness: 2, height: 2),
        ),
        ValueListenableBuilder<StaffModel>(
          valueListenable: _pickedStaff,
          builder: (context, pickedStaff, _) {
            return ValueListenableBuilder<List<DateTime>>(
              valueListenable: _timeStamps,
              builder: (context, value, _) {
                return ValueListenableBuilder<DateTime>(
                  valueListenable: _pickedTime,
                  builder: (context, picked, _) {
                    return ListTimeStamp(
                      staffId: _pickedStaff.value.id,
                      activeHours: value,
                      staffs: _listStaff,
                      pickedTime: picked,
                      onPickTimeStamp: (time) {
                        if (time != null) {
                          _pickedTime.value = time;
                          widget.onChanged?.call({
                            ...?widget.appointment,
                            'date': DateFormat("yyyy-MM-dd").format(_pickedTime.value),
                            'time': DateFormat("HH:mm").format(_pickedTime.value),
                            'staff_id': _pickedStaff.value.id,
                            'staff_name': _pickedStaff.value.name,
                          });
                        }
                      },
                      scheduledTimes: getScheduledTime(
                          activeHoursData: _activeHoursData, maxQuantity: _qty, staffId: _pickedStaff.value.id),
                      activeHoursData: _activeHoursData,
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
