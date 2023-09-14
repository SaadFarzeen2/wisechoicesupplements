import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:collection/collection.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ui/notification/notification_screen.dart';

import 'data.dart';

class ReasonStep extends StatefulWidget {
  final String? reason;
  final ValueChanged<String> changeReason;
  final VoidCallback nextStep;

  const ReasonStep({
    Key? key,
    this.reason,
    required this.changeReason,
    required this.nextStep,
  }) : super(key: key);

  @override
  State<ReasonStep> createState() => _ReasonStepState();
}

class _ReasonStepState extends State<ReasonStep> with Utility, AppBarMixin {
  final TextEditingController _controller = TextEditingController();

  String? _value;

  @override
  void initState() {
    if (widget.reason?.isNotEmpty == true) {
      _value = widget.reason;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.reason?.isNotEmpty == true) {
      TranslateType translate = AppLocalizations.of(context)!.translate;
      Map<String, String>? item =
          reasonData.firstWhereOrNull((element) => get(element, ['value'], '') == widget.reason);

      _controller.text = translate(get(item, ['label_name'], ''));
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: AppBar(
        leading: leading(),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: CirillaFixedBottom(
        childBottom: CirillaFixedBottomContainer(
          padding: paddingVerticalMedium.add(paddingHorizontal),
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _value?.isNotEmpty == true ? widget.nextStep : null,
              child: Text(translate('delete_account_reason_button')),
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: paddingVerticalLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NotificationScreen(
                  iconData: FontAwesomeIcons.userTimes,
                  title: Container(
                    margin: paddingHorizontal,
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(
                      translate('delete_account_txt'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  content: Container(
                    margin: paddingHorizontal,
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Text(
                      translate('delete_account_reason_description'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  isButton: false,
                ),
                Padding(
                  padding: paddingHorizontal.copyWith(top: itemPaddingLarge),
                  child: GestureDetector(
                    onTap: () async {
                      String? data = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return buildViewModal(
                            title: translate('delete_account_reason_dropdown_label'),
                            child: Column(
                              children: List.generate(reasonData.length, (index) {
                                Map<String, String> item = reasonData[index];
                                TextStyle? titleStyle = theme.textTheme.titleSmall;
                                TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);

                                String keyItem = get(item, ['value'], '');
                                String keyName = get(item, ['label_name'], '');

                                return CirillaTile(
                                  title: Text(translate(keyName),
                                      style: keyItem == _value ? activeTitleStyle : titleStyle),
                                  trailing: keyItem == _value
                                      ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor)
                                      : null,
                                  isChevron: false,
                                  onTap: () {
                                    Navigator.pop(context, keyItem);
                                  },
                                );
                              }),
                            ),
                          );
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                      );
                      if (data != null && data != _value) {
                        Map<String, String>? item =
                            reasonData.firstWhereOrNull((element) => get(element, ['value'], '') == data);
                        setState(() {
                          _value = data;
                          _controller.text = translate(get(item, ['label_name'], ''));
                        });
                        widget.changeReason(data);
                      }
                    },
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        enabled: false,
                        labelText: translate('delete_account_reason_dropdown_label'),
                        hintText: translate('delete_account_reason_dropdown_placeholder'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: const Icon(FeatherIcons.chevronDown, size: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildViewModal({required String title, Widget? child}) {
    ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: height / 2),
      padding: paddingHorizontal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: itemPaddingMedium, bottom: itemPaddingLarge),
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
          Flexible(child: SingleChildScrollView(child: child))
        ],
      ),
    );
  }
}
