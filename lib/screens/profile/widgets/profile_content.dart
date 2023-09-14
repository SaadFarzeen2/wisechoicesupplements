import 'package:flutter/material.dart';

abstract class ProfileContent extends StatefulWidget {
  final bool? enablePhone;
  final bool? enableHelpInfo;
  final String? phone;
  final Widget? footer;

  const ProfileContent({
    Key? key,
    this.enablePhone,
    this.enableHelpInfo,
    this.phone,
    this.footer,
  }) : super(key: key);

  @override
  State<ProfileContent> createState() => _ProfileContentState();

  @protected
  Widget buildInfo(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: child,
          )
        ],
      ),
    );
  }

  @protected
  Widget buildLayout(BuildContext context);
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.buildLayout(context),
        if (widget.footer is Widget)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: widget.footer,
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
