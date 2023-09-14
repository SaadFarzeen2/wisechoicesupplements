import 'package:flutter/material.dart';

const double buttonSize = 30.0;
const double buttonBorder = 4;

class CounterBooking extends StatefulWidget {
  const CounterBooking({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.onChangedValue,
    this.durationUnit,
    this.duration,
  }) : super(key: key);
  final int minValue;
  final int maxValue;
  final Function(int value) onChangedValue;
  final String? durationUnit;
  final int? duration;
  @override
  State<CounterBooking> createState() => _CounterBookingState();
}

class _CounterBookingState extends State<CounterBooking> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> _errorMessage = ValueNotifier("");
  @override
  void initState() {
    _controller.text = widget.minValue.toString();
    _controller.addListener(() {
      int? value = _parseValue(_controller.text);
      if (value != null) {
        widget.onChangedValue(value);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.durationUnit != null)
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              "Note: Your picked time must be in available date range.",
              maxLines: 2,
            ),
          ),
        if (widget.durationUnit != null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text("Duration"),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                int? value = _parseValue(_controller.text);
                if (value != null) {
                  value--;
                  if (value >= widget.minValue) {
                    _controller.text = (value).toString();
                  }
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(buttonBorder),
                      bottomLeft: Radius.circular(buttonBorder)),
                ),
                width: buttonSize,
                height: buttonSize,
                child: const Center(
                    child: Icon(
                  Icons.remove,
                  color: Colors.white,
                )),
              ),
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.black,
                width: 1,
              )),
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 7),
              child: Center(
                child: IntrinsicWidth(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        counterText: ""),
                    onChanged: (value) {
                      int? val = _parseValue(value);
                      if (val == null) {
                        _errorMessage.value = 'Invalid value';
                      } else {
                        _errorMessage.value = '';
                      }
                    },
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    maxLength: 15,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                int? value = _parseValue(_controller.text);
                if (value != null) {
                  value++;
                  if (value <= widget.maxValue) {
                    _controller.text = (value).toString();
                  }
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(buttonBorder),
                      bottomRight: Radius.circular(buttonBorder)),
                ),
                width: buttonSize,
                height: buttonSize,
                child: const Center(
                    child: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            if (widget.duration != null)
              (widget.duration! > 1)
                  ? Text("x${widget.duration} ${widget.durationUnit}s")
                  : Text("${widget.durationUnit}(s)")
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ValueListenableBuilder<String>(
          valueListenable: _errorMessage,
          builder: (context, error, _) {
            if (error.isNotEmpty) {
              return Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  int? _parseValue(String value) {
    int? result;
    result = int.tryParse(value);
    if (result != null) {
      if (result < widget.minValue || result > widget.maxValue) {
        return null;
      }
    }
    return result;
  }
}
