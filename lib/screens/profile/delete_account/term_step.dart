import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'data.dart';

class TermStep extends StatelessWidget with AppBarMixin {
  final VoidCallback nextStep;
  final VoidCallback backStep;

  const TermStep({
    Key? key,
    required this.nextStep,
    required this.backStep,
  }) : super(key: key);

  Widget buildItemView({
    required IconData icon,
    required String name,
    required ThemeData theme,
    required TranslateType translate,
  }) {
    return Container(
      padding: paddingMedium,
      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: borderRadius),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.primaryColor,
            size: 32,
          ),
          const SizedBox(width: itemPaddingMedium),
          Expanded(
            child: CirillaHtml(html: translate(name)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: AppBar(
        leading: iconButtonLeading(onPressed: backStep),
        title: Text(translate('delete_account_txt')),
        centerTitle: true,
        shadowColor: Colors.transparent,
      ),
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
                    child: Text(translate('delete_account_term_cancel')),
                  ),
                ),
              ),
              const SizedBox(width: itemPaddingMedium),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: nextStep,
                    child: Text(translate('delete_account_term_next')),
                  ),
                ),
              ),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: paddingHorizontal.copyWith(top: itemPadding, bottom: itemPaddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate('delete_account_term_title'), style: theme.textTheme.bodyMedium),
              Text(translate('delete_account_term_subtitle'),
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
              const SizedBox(height: itemPaddingMedium),
              ...List.generate(termData.length, (index) {
                Map<String, dynamic> item = termData[index];

                IconData icon = get(item, ['icon']);
                String name = get(item, ['label_name']);

                double padBottom = index < termData.length - 1 ? itemPaddingMedium : 0;

                return Padding(
                  padding: EdgeInsets.only(bottom: padBottom),
                  child: buildItemView(
                    icon: icon,
                    name: name,
                    theme: theme,
                    translate: translate,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
