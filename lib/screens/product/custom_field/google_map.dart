import 'dart:async';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FieldGoogleMap extends StatelessWidget with Utility {
  final dynamic value;

  const FieldGoogleMap({
    Key? key,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String address = '';
    double lat = 0;
    double lng = 0;
    double zoom = initZoom;

    if (value is Map) {
      address = get(value, ['address'], '');
      lat = ConvertData.stringToDouble(get(value, ['lat'], 0));
      lng = ConvertData.stringToDouble(get(value, ['lng'], 0));
      zoom = ConvertData.stringToDouble(get(value, ['zoom'], initZoom));
    }

    if (address.isEmpty) {
      return Container();
    }

    return MapView(
      address: address,
      lat: lat,
      lng: lng,
      zoom: zoom,
    );
  }
}

class MapView extends StatefulWidget {
  final String address;
  final double lat;
  final double lng;
  final double zoom;

  const MapView({
    Key? key,
    required this.address,
    required this.lat,
    required this.lng,
    this.zoom = initZoom,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with Utility {
  final Completer<GoogleMapController> _controller = Completer();
  Map<String, Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lng),
          zoom: widget.zoom,
        ),
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        tiltGesturesEnabled: false,
        markers: markers.values.toSet(),
        onMapCreated: (GoogleMapController controller) => _onMapCreated(controller),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);

    setState(() {
      markers.clear();
      markers['0'] = Marker(
        markerId: const MarkerId(''),
        position: LatLng(widget.lat, widget.lng),
        infoWindow: InfoWindow(
          title: widget.address,
        ),
      );
    });
  }
}
