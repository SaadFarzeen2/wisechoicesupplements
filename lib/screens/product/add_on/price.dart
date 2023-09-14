import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/product/add_on/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceField extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function onChange;
  final AddOnData? value;
  final int max;
  final int min;
  final String? error;

  const PriceField({
    Key? key,
    required this.item,
    required this.onChange,
    this.value,
    this.max = 0,
    this.min = 0,
    this.error,
  }) : super(key: key);

  @override
  State<PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<PriceField> with Utility {
  final TextEditingController _controller = TextEditingController();
  bool enableMinus = true;
  bool enablePlus = true;

  @override
  void initState() {
    String text = widget.value?.string?.value ?? '';
    bool checkEmptyValue = !(widget.value?.string?.value.isNotEmpty == true);

    _controller.text = text;
    int? qty = int.tryParse(text);

    if ((!checkEmptyValue && qty == null) || (qty != null && qty <= widget.min)) {
      enableMinus = false;
    }
    if (widget.max != 0 && ((!checkEmptyValue && qty == null) || (qty != null && qty >= widget.max))) {
      enablePlus = false;
    }
    _controller.addListener(() {
      if (_controller.text == '-') {
        _controller.clear();
      }
      _onChange(context, _controller.text != '-' ? _controller.text : '');
    });
    super.initState();
  }

  _onChange(BuildContext context, String str) {
    int? qty = int.tryParse(str);

    setState(() {
      enableMinus = qty == null || qty > widget.min;
      enablePlus = widget.max == 0 || (qty == null || qty < widget.max);
    });

    String priceType = get(widget.item, ['price_type'], 'flat_fee');

    widget.onChange(
      AddOnData(
        type: AddOnDataType.string,
        string: AddOnString(
          value: str,
          price: qty != null ? qty.toDouble() : 0,
          priceType: priceType,
          duration: 0,
          durationType: 'flat_time',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    int? qty = int.tryParse(_controller.text);

    Widget suffix = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          decoration: BoxDecoration(
            color: enablePlus ? theme.primaryColor : theme.colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              if (enablePlus) {
                int visit = qty != null ? qty + 1 : 1;
                setState(() {
                  _controller.text = '$visit';
                });
              }
            },
            icon: const Icon(FontAwesomeIcons.plus, size: 12),
            color: enablePlus ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            constraints: const BoxConstraints(maxWidth: 30),
          ),
        )
      ],
    );

    Widget prefix = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: enableMinus ? theme.primaryColor : theme.colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              if (enableMinus) {
                int visit = qty != null
                    ? qty - 1
                    : widget.min < 0
                        ? -1
                        : 0;
                setState(() {
                  _controller.text = '$visit';
                });
              }
            },
            icon: const Icon(FontAwesomeIcons.minus, size: 12),
            color: enableMinus ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            constraints: const BoxConstraints(maxWidth: 30),
          ),
        )
      ],
    );

    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        suffixIcon: suffix,
        prefixIcon: prefix,
        errorText: widget.error,
      ),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
    );
  }
}
