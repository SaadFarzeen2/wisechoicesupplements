import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';

class LookingLocationScreen extends StatelessWidget {
  final String? locationTitle;
  final Icon? icon;

  const LookingLocationScreen({
    Key? key,
    this.locationTitle,
    this.icon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              translate('search_select_looking_location'),
              style: theme.textTheme.bodySmall,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 13, top: 24, bottom: 24),
              child: icon ??
                  const Icon(
                    FontAwesomeIcons.mapMarked,
                    size: 106,
                  ),
            ),
            Text(
              locationTitle ?? '396 NY-52, Woodbourne, NY 12788',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
