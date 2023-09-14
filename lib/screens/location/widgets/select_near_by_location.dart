import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter/material.dart';

import 'package:cirilla/models/location/near_place.dart';
import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/service/helpers/google_place_helper.dart';

import 'item_location.dart';

class SelectNearByLocation extends StatefulWidget {
  final UserLocation location;

  const SelectNearByLocation({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  State<SelectNearByLocation> createState() => _SelectNearByLocationState();
}

class _SelectNearByLocationState extends State<SelectNearByLocation> with SnackMixin{
  List<NearPlace> _data = [];
  bool _loading = true;

  @override
  void didChangeDependencies() {
    _getNearByLocation(widget.location);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant SelectNearByLocation oldWidget) {
    if (widget.location.lat != oldWidget.location.lat || widget.location.lng != oldWidget.location.lng) {
      _getNearByLocation(widget.location);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _getNearByLocation(UserLocation location) async {
    try {
      setState(() {
        _loading = true;
      });
      List<NearPlace> data = await GooglePlaceApiHelper().getNearbySearch(
        queryParameters: {'radius': 1500, 'location': '${location.lat},${location.lng}'},
      );
      setState(() {
        _loading = false;
        _data = data;
      });
    } catch (_) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return buildLoading();
    }

    return Column(
      children: List.generate(_data.length, (index) {
        NearPlace item = _data[index];

        String subtitle = item.address;
        List<String> splitSubtitle = subtitle.split(',');
        String title = splitSubtitle.isNotEmpty ? splitSubtitle[0] : '';

        return ItemLocation(
          title: title,
          subTitle: '',
          onTap: () async {
            await GooglePlaceApiHelper().getPlaceDetailFromId(queryParameters: {
              'place_id': item.placeId,
            }).then((value) {
              Navigator.pop(context, {
                'user_location': item.toUserLocation(),
                'place': value,
                'address2': subtitle,
              });
            }).catchError((object, stackTrace){
              showError(context, object.toString());
            });
          },
        );
      }),
    );
  }

  Widget buildLoading() {
    return Column(
      children: List.generate(5, (index) {
        return ItemLocation(
          loading: true,
        );
      }),
    );
  }
}
