import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/location/prediction.dart';
import 'package:cirilla/screens/location/widgets/item_location.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:ui/notification/notification_screen.dart';

class Results extends StatefulWidget {
  final String? search;
  final GooglePlaceApiHelper apiClient;
  final List<Prediction> data;

  const Results({
    Key? key,
    this.search,
    required this.apiClient,
    required this.data,
  }) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    if (widget.search!.length >= 2 && widget.search!.trim() != '') {
      return ListView.builder(
        itemBuilder: (context, index) {
          Prediction item = widget.data[index];
          return Padding(
            padding: paddingHorizontal,
            child: ItemLocation(
              title: item.structuredFormatting.mainText,
              subTitle: item.structuredFormatting.secondaryText,
              search: widget.search ?? '',
              onTap: () {
                Navigator.pop(context, item);
              },
            ),
          );
        },
        itemCount: widget.data.length,
      );
    }
    return Center(
      child: NotificationScreen(
        title: Text(
          translate('search_location'),
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          translate('search_enter_your_address'),
          style: theme.textTheme.bodyMedium,
        ),
        iconData: FontAwesomeIcons.mapMarked,
        isButton: false,
      ),
    );
  }
}
