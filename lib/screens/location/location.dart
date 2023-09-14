import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:ui/ui.dart';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/models/location/prediction.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/auth/location_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/models/location/place.dart';
import 'package:cirilla/service/helpers/google_place_helper.dart';

import 'search_location.dart';
import 'widgets/item_address.dart';
import 'widgets/use_my_current_location.dart';

class LocationScreen extends StatefulWidget {
  static const routeName = '/location';

  final SettingStore? store;

  const LocationScreen({
    Key? key,
    this.store,
  }) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> with AppBarMixin, LoadingMixin {
  final apiClient = GooglePlaceApiHelper();

  late LocationStore _locationStore;

  bool _loading = false;

  @override
  void didChangeDependencies() {
    _locationStore = Provider.of<AuthStore>(context).locationStore;

    super.didChangeDependencies();
  }

  void onPressed(BuildContext context) async {
    try {
      TranslateType translate = AppLocalizations.of(context)!.translate;
      Prediction? result = await showSearch(
        context: context,
        delegate: SearchLocationScreen(context, translate),
      );

      if (result == null || result.placeId == null) return;
      setState(() {
        _loading = true;
      });

      Place place = await apiClient.getPlaceDetailFromId(queryParameters: {'place_id': result.placeId});

      _locationStore.setLocation(location: place.toUserLocation());

      setState(() {
        _loading = false;
      });

      if (mounted) Navigator.pop(context);
    } catch (_) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(builder: (_) {
      UserLocation location = _locationStore.location;
      List<UserLocation> data = _locationStore.locations.where((e) => e.id != location.id).toList();
      return Stack(
        children: [
          Scaffold(
            appBar: baseStyleAppBar(
              context,
              title: translate('location_txt'),
              actions: [
                InkResponse(
                  onTap: () => onPressed(context),
                  radius: 29,
                  child: const Icon(
                    FeatherIcons.search,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            bottomNavigationBar: Container(
              padding: paddingHorizontal.add(paddingVerticalLarge),
              decoration: BoxDecoration(color: theme.canvasColor, boxShadow: initBoxShadow),
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, FormAddressScreen.routeName),
                  style: ElevatedButton.styleFrom(
                    textStyle: theme.textTheme.titleSmall,
                  ),
                  child: Text(translate('location_button_add_address')),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: paddingHorizontal, child: UseMyCurrentLocation()),
                  Visibility(
                    visible: location.lat != null || location.lng != null,
                    child: ItemAddress(
                      location: location,
                      padding: paddingHorizontal.add(paddingVerticalLarge),
                      isSelect: true,
                      addressBasic: true,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectLocationScreen(
                              store: widget.store,
                              location: location,
                            ),
                          ),
                        );
                        if (result != null && result['user_location'] is UserLocation) {
                          await _locationStore.setLocation(location: result['user_location']);
                        }
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: paddingHorizontal.add(paddingVerticalMedium),
                    color: theme.colorScheme.surface,
                    child: Text(
                      translate('location_saved'),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color),
                    ),
                  ),
                  Column(
                    children: List.generate(data.length, (index) {
                      UserLocation item = data[index];
                      return DismissibleItem(
                        item: item.id!,
                        onDismissed: (direction) => _locationStore.deleteLocation(id: item.id!),
                        confirmDismiss: (DismissDirection direction) => Future.value(true),
                        child: Column(
                          children: [
                            ItemAddress(
                              location: item,
                              padding: paddingHorizontal.add(paddingVerticalLarge),
                              onTap: () async {
                                setState(() {
                                  _loading = true;
                                });
                                await _locationStore.setLocation(location: item);
                                setState(() {
                                  _loading = false;
                                });
                                if (mounted) Navigator.pop(context);
                              },
                            ),
                            const Divider(height: 1, thickness: 1, endIndent: layoutPadding, indent: layoutPadding),
                          ],
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
          if (_loading) entryLoading(context),
        ],
      );
    });
  }
}
