import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalDateTime extends StatefulWidget {
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final CupertinoDatePickerMode mode;

  const ModalDateTime({
    Key? key,
    this.value,
    required this.onChanged,
    this.mode = CupertinoDatePickerMode.date,
  }) : super(key: key);

  @override
  State<ModalDateTime> createState() => _ModalDateTimeState();
}

class _ModalDateTimeState extends State<ModalDateTime> {
  late DateTime _date;

  @override
  void initState() {
    _date = widget.value ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: widget.mode,
                initialDateTime: _date,
                onDateTimeChanged: (DateTime newDateTime) => setState(() {
                  _date = newDateTime;
                }),
              ),
            ),
          ),
        ),
        const SizedBox(height: itemPaddingMedium),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => widget.onChanged(null),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.textTheme.titleSmall?.color,
                    backgroundColor: theme.colorScheme.surface,
                  ),
                  child: Text(translate('address_modal_date_cancel')),
                ),
              ),
            ),
            const SizedBox(width: itemPaddingMedium),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => widget.onChanged(_date),
                  child: Text(
                    translate('address_modal_date_ok'),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
