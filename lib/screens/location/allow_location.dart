import 'dart:async';
import 'package:cirilla/constants/credentials.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:flutter/material.dart';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:provider/provider.dart';

import 'package:ui/notification/notification_screen.dart';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/location/place.dart';
import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/screens/location/search_location.dart';
import 'package:cirilla/screens/location/widgets/looking_location.dart';
import 'package:cirilla/service/helpers/google_place_helper.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/auth/location_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/setting/setting_store.dart';

class AllowLocationScreen extends StatefulWidget {
  static const routeName = '/location/allow_location';
  final SettingStore? store;

  const AllowLocationScreen({
    Key? key,
    this.store,
  }) : super(key: key);

  @override
  State<AllowLocationScreen> createState() => _AllowLocationScreenState();
}

class _AllowLocationScreenState extends State<AllowLocationScreen> with AppBarMixin, SnackMixin {
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;

  late LocationStore _locationStore;
  late SettingStore _settingStore;

  bool _loading = false;
  bool _listen = false;

  @override
  void initState() {
    _handlePermission();
    _toggleServiceStatusStream();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _locationStore = Provider.of<AuthStore>(context).locationStore;
    _settingStore = Provider.of<SettingStore>(context);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_serviceStatusStreamSubscription != null) {
      _serviceStatusStreamSubscription!.cancel();
      _serviceStatusStreamSubscription = null;
    }

    super.dispose();
  }

  /// Handle check and open request permission
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    await _getLocation();

    return true;
  }

  /// Subscribe service status
  /// In Android, iOS we can open settings
  /// In Web we can't
  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null && !isWeb) {
      final serviceStatusStream = Geolocator.getServiceStatusStream();

      _serviceStatusStreamSubscription = serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        if (serviceStatus == ServiceStatus.enabled && _listen) {
          _handlePermission();
        }
      });
    }
  }

  void _openAppSettings() async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    LocationPermission permission = await Geolocator.checkPermission();

    /// Open settings do not support Web, we show message to user
    if (isWeb && mounted && permission == LocationPermission.deniedForever) {
      showError(context, translate('search_guide', {'appName': Strings.appName}));
      return;
    }

    /// Open setting on the app
    bool allow = await _handlePermission();
    if (!allow && !isWeb) {
      setState(() {
        _listen = true;
      });
      await Geolocator.openAppSettings();
    }
  }

  Future<void> _getLocation() async {
    setState(() {
      _loading = true;
    });

    final position = await Geolocator.getCurrentPosition();

    GoogleGeocoding googleGeocoding = GoogleGeocoding(googleMapApiKey);
    GeocodingResponse? reverse = await googleGeocoding.geocoding.getReverse(LatLon(
      position.latitude,
      position.longitude,
    ));
    _locationStore.setLocation(
      location: UserLocation(
        lat: position.latitude,
        lng: position.longitude,
        address: reverse?.results != null && reverse!.results!.isNotEmpty ? reverse.results![0].formattedAddress : '',
        tag: '',
      ),
    );

    setState(() {
      _loading = false;
    });

    await _settingStore.closeAllowLocation();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: _loading ? _buildLoading() : _buildContent(context),
      bottomNavigationBar: !_loading
          ? Padding(
              padding: paddingHorizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _openAppSettings,
                      style: ElevatedButton.styleFrom(padding: paddingVerticalSmall),
                      child: Text(translate('search_allow_btn')),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await showSearch(
                          context: context,
                          delegate: SearchLocationScreen(context, translate),
                        );
                        if (result != null) {
                          setState(() {
                            _loading = true;
                          });

                          Place place = await GooglePlaceApiHelper().getPlaceDetailFromId(queryParameters: {
                            'place_id': result.placeId,
                          });
                          await _locationStore.setLocation(location: place.toUserLocation());

                          setState(() {
                            _loading = false;
                          });

                          await _settingStore.closeAllowLocation();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: theme.textTheme.titleMedium?.color,
                        backgroundColor: theme.colorScheme.surface,
                        padding: paddingVerticalSmall,
                      ),
                      child: Text(translate('search_enter_btn')),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildLoading() {
    return const LookingLocationScreen(
      locationTitle: '',
    );
  }

  Widget _buildContent(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Center(
      child: Padding(
        padding: paddingHorizontal,
        child: NotificationScreen(
          title: Text(translate('search_you_are_turning_off_location_access'), style: theme.textTheme.titleMedium),
          content: Text(
            translate('search_allowing'),
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          iconData: FontAwesomeIcons.mapMarked,
          isButton: false,
        ),
      ),
    );
  }
}
