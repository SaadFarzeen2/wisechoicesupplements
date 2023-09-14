import 'dart:async';

import 'package:cirilla/constants/credentials.dart';
import 'package:flutter/material.dart';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:cirilla/service/helpers/google_place_helper.dart';
import 'package:cirilla/models/location/place.dart';

import 'search_location.dart';
import 'widgets/item_location.dart';
import 'widgets/select_near_by_location.dart';

class SelectLocationScreen extends StatefulWidget {
  static const routeName = '/location/select_location';

  final SettingStore? store;
  final UserLocation? location;

  const SelectLocationScreen({
    Key? key,
    this.store,
    this.location,
  }) : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> with AppBarMixin {
  final Completer<GoogleMapController> _controller = Completer();

  final ValueNotifier<UserLocation> _position = ValueNotifier<UserLocation>(UserLocation(
    lat: initLat,
    lng: initLng,
    address: 'Apple Campus, CA, US',
  ));

  final ValueNotifier<bool> _showNearPlace = ValueNotifier<bool>(false);

  bool _loading = true;

  bool _listen = false;

  Place? _place;

  @override
  void didChangeDependencies() {
    _restoreLocation();
    super.didChangeDependencies();
  }

  void _restoreLocation() async {
    final GoogleMapController controller = await _controller.future;

    setState(() {
      _loading = false;
    });

    if (widget.location?.lng == null || widget.location?.lat == null) return;

    UserLocation location = widget.location!;

    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(location.lat ?? initLat, location.lng ?? initLng),
      zoom: initZoom,
    )));

    setState(() {
      _position.value = widget.location!;
    });
  }

  /// Get center map
  Future<LatLng> getCenter() async {
    final GoogleMapController controller = await _controller.future;
    LatLngBounds bounds = await controller.getVisibleRegion();
    LatLng center = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
      (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
    );

    return center;
  }

  /// Called when camera movement has ended
  Future<void> _onCameraIdle() async {
    if (!_listen) {
      setState(() {
        _listen = true;
      });
      return;
    }

    LatLng center = await getCenter();
    GoogleGeocoding googleGeocoding = GoogleGeocoding(googleMapApiKey);
    GeocodingResponse? reverse = await googleGeocoding.geocoding.getReverse(LatLon(
      center.latitude,
      center.longitude,
    ));

    Place place = await GooglePlaceApiHelper().getPlaceDetailFromId(queryParameters: {
      'place_id': reverse?.results?.first.placeId,
    });
    _place = place;

    UserLocation location = UserLocation(
      id: reverse?.results?.first.placeId,
      lat: center.latitude,
      lng: center.longitude,
      address: reverse?.results?.first.formattedAddress,
      tag: '',
    );

    if (location.lat != _position.value.lat || location.lng != _position.value.lng) {
      _position.value = location;
    }
  }

  /// Handle search address
  ///
  void _onSearch(BuildContext context) async {
    try {
      TranslateType translate = AppLocalizations.of(context)!.translate;
      final searchDelegate = SearchLocationScreen(context, translate);
      final GoogleMapController controller = await _controller.future;
      if (mounted) {}
      final result = await showSearch(
        context: context,
        delegate: searchDelegate,
      );
      if (result != null && result.placeId?.isNotEmpty == true) {
        setState(() {
          _loading = true;
          _listen = false;
        });

        Place place = await GooglePlaceApiHelper().getPlaceDetailFromId(queryParameters: {
          'place_id': result.placeId,
        });
        _place = place;

        await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(place.location.latitude, place.location.longitude),
          zoom: initZoom,
        )));

        setState(() {
          _loading = false;
          _position.value = place.toUserLocation();
        });
      }
    } catch (_) {
      setState(() {
        _loading = false;
      });
    }
  }

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

    return true;
  }

  Future<void> _getLocation() async {
    bool enabled = await _handlePermission();

    if (!enabled) {
      await Geolocator.openAppSettings();
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    final GoogleMapController controllerMarker = await _controller.future;
    controllerMarker.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: enableBearing,
      target: LatLng(position.latitude, position.longitude),
      tilt: enableTilt,
      zoom: enableZoom,
    )));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: translate('select_location_txt'),
        actions: [
          InkResponse(
            onTap: () => _onSearch(context),
            radius: 29,
            child: const Icon(
              FeatherIcons.search,
              size: 20,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: _showNearPlace,
        builder: (_, showNearPlace, __) => AnimatedContainer(
          constraints: BoxConstraints(
            maxHeight: 0.5 * heightScreen,
            minHeight: showNearPlace ? 0.5 * heightScreen : 100,
          ),
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: paddingHorizontal,
                child: ValueListenableBuilder<UserLocation>(
                  valueListenable: _position,
                  builder: (_, value, __) => _buildPlaceInfo(value),
                ),
              ),
              Container(
                width: double.infinity,
                height: 48,
                padding: paddingHorizontal,
                child: ElevatedButton(
                  onPressed: !_loading
                      ? () => Navigator.pop(context, {
                            'user_location': _position.value,
                            'place': _place,
                          })
                      : () => {},
                  child: Text(translate('select_location_button_select')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: CirillaTile(
                  title: Text(
                    translate('select_location_near_place'),
                    style: theme.textTheme.titleMedium,
                  ),
                  trailing: Icon(
                    showNearPlace ? FeatherIcons.chevronDown : FeatherIcons.chevronRight,
                    size: 20,
                    color: theme.textTheme.titleMedium!.color,
                  ),
                  isChevron: false,
                  isDivider: false,
                  onTap: () {
                    _showNearPlace.value = !showNearPlace;
                  },
                ),
              ),
              showNearPlace
                  ? Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        child: ValueListenableBuilder<UserLocation>(
                          valueListenable: _position,
                          builder: (_, value, __) => SelectNearByLocation(location: value),
                        ),
                      ),
                    )
                  : const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          _buildMap(),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 30,
            child: Center(
              child: Icon(FontAwesomeIcons.mapMarkerAlt, size: 30, color: ColorBlock.redBase),
            ),
          ),
          PositionedDirectional(
            bottom: 16,
            end: 20,
            child: InkWell(
              onTap: _getLocation,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  shape: BoxShape.circle,
                  boxShadow: initBoxShadow,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.my_location, color: theme.textTheme.titleMedium?.color),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(_position.value.lat ?? initLat, _position.value.lng ?? initLng),
        zoom: initZoom,
      ),
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      onCameraIdle: _onCameraIdle,
    );
  }

  Widget _buildPlaceInfo(UserLocation userLocation) {
    String subtitle = userLocation.address ?? '';
    List<String> splitSubtitle = subtitle.split(',');
    String title = splitSubtitle.isNotEmpty ? splitSubtitle[0] : '';

    return ItemLocation(
      primaryIcon: true,
      title: title,
      subTitle: subtitle,
      loading: false,
      padding: paddingVerticalLarge,
      isDivider: false,
    );
  }
}
