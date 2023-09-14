import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/constants/constants.dart';

class ItemAddress extends StatelessWidget {
  final UserLocation location;
  final EdgeInsetsGeometry? padding;
  final GestureTapCallback? onTap;
  final bool isSelect;
  final bool addressBasic;
  final String? title;
  final String? subTitle;

  const ItemAddress({
    Key? key,
    required this.location,
    this.padding,
    this.onTap,
    this.isSelect = false,
    this.addressBasic = false,
    this.title = '',
    this.subTitle = '',
  }) : super(key: key);

  buildInfo(BuildContext context, ThemeData theme) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    late String title;
    switch (location.tag) {
      case 'home':
        title = translate('location_address_home');
        break;
      case 'office':
        title = translate('location_address_office');
        break;
      default:
        String nameTag = location.tag ?? '';
        if (nameTag.isNotEmpty) {
          title = nameTag;
        } else {
          String address = location.address ?? '';
          List<String> splitAddress = address.split(',');
          title = splitAddress.isNotEmpty ? splitAddress[0] : '';
        }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              Text(location.address!, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: itemPaddingMedium),
        Column(
          children: [
            InkResponse(
              onTap: () {
                Navigator.pushNamed(context, FormAddressScreen.routeName, arguments: {'location': location});
              },
              radius: 25,
              child: Icon(FeatherIcons.edit, size: 20, color: theme.textTheme.bodySmall?.color),
            ),
            if (isSelect) ...[
              const SizedBox(height: layoutPadding),
              Icon(FeatherIcons.check, size: 20, color: theme.primaryColor),
            ],
          ],
        )
      ],
    );
  }

  buildBasic(ThemeData theme) {
    String text = location.tag?.trim() != '' ? location.tag ?? '' : location.address!.split(',')[0];
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: theme.textTheme.titleSmall),
              Text(location.address ?? '', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        if (isSelect) ...[
          const SizedBox(width: itemPaddingMedium),
          if (isSelect) Icon(FeatherIcons.check, size: 20, color: theme.primaryColor),
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: addressBasic ? buildBasic(theme) : buildInfo(context, theme),
      ),
    );
  }
}
