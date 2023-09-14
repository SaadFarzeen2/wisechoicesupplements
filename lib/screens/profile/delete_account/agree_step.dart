import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ui/notification/notification_screen.dart';

class AgreeStep extends StatelessWidget with Utility, AppBarMixin, LoadingMixin {
  final bool isAgree;
  final ValueChanged<bool> changeAgree;
  final VoidCallback nextStep;
  final VoidCallback backStep;
  final bool loading;

  const AgreeStep({
    Key? key,
    this.isAgree = false,
    required this.changeAgree,
    required this.nextStep,
    required this.backStep,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: AppBar(
        leading: iconButtonLeading(onPressed: backStep),
        shadowColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: CirillaFixedBottom(
        childBottom: CirillaFixedBottomContainer(
          padding: paddingVerticalMedium.add(paddingHorizontal),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.textTheme.titleMedium?.color,
                      backgroundColor: theme.colorScheme.surface,
                    ),
                    child: Text(translate('delete_account_agree_cancel')),
                  ),
                ),
              ),
              const SizedBox(width: itemPaddingMedium),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isAgree
                        ? () {
                            if (!loading) {
                              nextStep();
                            }
                          }
                        : null,
                    child: loading
                        ? entryLoading(context, color: theme.colorScheme.onPrimary)
                        : Text(translate('delete_account_agree_send')),
                  ),
                ),
              ),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                NotificationScreen(
                  iconData: FontAwesomeIcons.userTimes,
                  title: Padding(
                    padding: paddingHorizontal,
                    child: Text(
                      translate('delete_account_agree_title'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  content: Padding(
                    padding: paddingHorizontal,
                    child: Text(
                      translate('delete_account_agree_subtitle'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  isButton: false,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CirillaRadio.iconCheck(
                      isSelect: isAgree,
                      onChange: changeAgree,
                    ),
                    const SizedBox(width: itemPaddingSmall),
                    Flexible(
                      child: Text(
                        translate('delete_account_agree_checkbox'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isAgree ? theme.textTheme.titleMedium?.color : null,
                          fontWeight: isAgree ? theme.textTheme.titleMedium?.fontWeight : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
