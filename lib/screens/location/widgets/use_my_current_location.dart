import 'package:cirilla/constants/credentials.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:provider/provider.dart';

import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/auth/location_store.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';

class UseMyCurrentLocation extends StatefulWidget {
  const UseMyCurrentLocation({Key? key}) : super(key: key);

  @override
  State<UseMyCurrentLocation> createState() => _UseMyCurrentLocationState();
}

class _UseMyCurrentLocationState extends State<UseMyCurrentLocation> {
  late LocationStore _locationStore;

  bool _loading = false;

  @override
  void didChangeDependencies() {
    _locationStore = Provider.of<AuthStore>(context).locationStore;

    super.didChangeDependencies();
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
    setState(() {
      _loading = true;
    });

    bool enabled = await _handlePermission();

    if (!enabled) {
      setState(() {
        _loading = false;
      });
      await Geolocator.openAppSettings();
      return;
    }

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
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return CirillaTile(
      title: Text(
        translate('location_current_location'),
        style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color),
      ),
      trailing: _loading
          ? const SizedBox(width: 25, height: 25, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(
              Icons.my_location,
              size: 20,
              color: theme.textTheme.titleMedium?.color,
            ),
      isChevron: false,
      height: 50,
      onTap: () => _getLocation(),
    );
  }
}
