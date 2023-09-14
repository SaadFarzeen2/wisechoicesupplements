import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter/material.dart';

class StepAddress extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final double padHorizontal;

  // The widget show info cart totals
  final Widget totals;

  // The widget show list shipping methods
  final Widget shippingMethods;

  // The widget show shipping / billing address form
  final Widget address;

  // The widget Bottom
  final Widget bottomWidget;

  const StepAddress({
    Key? key,
    required this.bottomWidget,
    this.padding,
    this.padHorizontal = layoutPadding,
    required this.totals,
    required this.shippingMethods,
    required this.address,
  }) : super(key: key);

  @override
  State<StepAddress> createState() => _StepAddressState();
}

class _StepAddressState extends State<StepAddress> with LoadingMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: widget.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.padHorizontal),
                  child: widget.address,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: widget.padHorizontal),
                  child: widget.shippingMethods,
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.padHorizontal),
                  child: widget.totals,
                ),
              ],
            ),
          ),
        ),
        widget.bottomWidget,
      ],
    );
  }
}
