import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/url_launcher.dart';

class HorizontalContact extends StatelessWidget with AppBarMixin, Utility {
  /// customize items
  final List items;

  /// enable icon direction map
  final bool? enableDirectMap;

  /// widget MapView
  final Widget mapView;

  /// widget FloatingActionButtonLocation
  final Widget? buttonLocation;

  final Function(double lat, double lng, double bearing, double tilt, double zoom) gotoMarker;

  final String? languageKey;

  const HorizontalContact({
    Key? key,
    required this.items,
    required this.mapView,
    required this.gotoMarker,
    this.enableDirectMap = true,
    this.buttonLocation,
    this.languageKey = 'text',
  }) : super(key: key);

  void goAddress(dynamic item) {
    double? lat = ConvertData.stringToDouble(get(item, ['data', 'lat'], initLat), initLat);
    double? lng = ConvertData.stringToDouble(get(item, ['data', 'lng'], initLng), initLng);
    double? bearing = ConvertData.stringToDouble(get(item, ['data', 'bearing'], enableBearing), enableBearing);
    double? tilt = ConvertData.stringToDouble(get(item, ['data', 'tilt'], enableTilt), enableTilt);
    double? zoom = ConvertData.stringToDouble(get(item, ['data', 'zoom'], enableZoom), enableZoom);
    gotoMarker(lat, lng, bearing, tilt, zoom);
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    int count = items.length;

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      child: Scaffold(
        appBar: baseStyleAppBar(context, title: translate('contact_us')),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: buttonLocation,
        bottomSheet: count > 0
            ? Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black.withOpacity(0.2)
                    ], // red to yellowepeats the gradient over the canvas
                  ),
                ),
                child: SingleChildScrollView(
                  padding: paddingHorizontal.add(paddingVerticalLarge),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      count,
                      (index) {
                        dynamic item = items.elementAt(index);

                        // info
                        String heading = get(item, ['data', 'titleHeading', languageKey], '');

                        EdgeInsetsDirectional padding = EdgeInsetsDirectional.only(end: index < count - 1 ? 16 : 0);
                        double? widthItem = count < 2 ? width - 40 : null;

                        return Padding(
                          padding: padding,
                          child: ContactContainedItem(
                            headOffice: Text(heading, style: theme.textTheme.titleLarge),
                            directionMap: enableDirectMap!
                                ? InkWell(
                                    onTap: () => goAddress(item),
                                    borderRadius: borderRadius,
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: theme.primaryColor),
                                        borderRadius: borderRadius,
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(FeatherIcons.cornerUpRight, size: 14, color: theme.primaryColor),
                                    ),
                                  )
                                : null,
                            description: Info(item: item, languageKey: languageKey, goAddress: goAddress),
                            width: widthItem,
                            padding: paddingLarge,
                            color: theme.scaffoldBackgroundColor,
                            shape: const RoundedRectangleBorder(borderRadius: borderRadius),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            : null,
        body: mapView,
      ),
    );
  }
}

class ItemInfo {
  final Map? icon;
  final String? text;
  final Function? action;

  ItemInfo({
    this.icon,
    this.text,
    this.action,
  });
}

class Info extends StatelessWidget with Utility {
  final dynamic item;
  final String? languageKey;
  final double pad;
  final Function(dynamic item)? goAddress;
  final bool disableOnClick;

  Info({Key? key, this.item, this.languageKey = 'text', this.pad = 0, this.goAddress, this.disableOnClick = false})
      : super(key: key);

  List<ItemInfo> getListItem() {
    Map iconPhoneData = get(item, ['data', 'iconPhone'], {});

    String? phoneData = get(item, ['data', 'titlePhone', languageKey], '0123456789');

    Map iconMailData = get(item, ['data', 'iconMail'], {});

    String? emailData = get(item, ['data', 'titleEmail', languageKey], '');

    Map iconAddressData = get(item, ['data', 'iconAddress'], {});

    String? addressData = get(item, ['data', 'titleAddress', languageKey], '');
    return [
      if (phoneData != '' && phoneData != null)
        ItemInfo(
            icon: iconPhoneData,
            text: phoneData,
            action: () {
              launch("tel://${phoneData.replaceAll(' ', '')}");
            }),
      if (emailData != '' && emailData != null)
        ItemInfo(icon: iconMailData, text: emailData, action: () => launch('mailto:$emailData')),
      if (addressData != '' && addressData != null)
        ItemInfo(
            icon: iconAddressData,
            text: addressData,
            action: () {
              if (goAddress != null) {
                goAddress!(item);
              }
            }),
    ].toList();
  }

  @override
  Widget build(BuildContext context) {
    List<ItemInfo> data = getListItem();
    return Column(
      children: List.generate(data.length, (index) {
        ItemInfo value = data.elementAt(index);
        double padItem = index < data.length - 1 ? pad : 0;
        return Padding(
          padding: EdgeInsets.only(bottom: padItem, top: itemPadding),
          child: InkWell(
            onTap: () {
              if (disableOnClick == true) return;
              value.action!();
            },
            child: Row(
              children: [
                CirillaIconBuilder(data: value.icon, size: 16),
                const SizedBox(width: 16),
                Expanded(
                    child: Text(
                  value.text!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).textTheme.titleMedium?.color),
                ))
              ],
            ),
          ),
        );
      }),
    );
  }
}
