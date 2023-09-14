import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/widgets/cirilla_vendor_item.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

import 'view_grid.dart';
import 'view_list.dart';
import 'view_carousel.dart';

class LayoutMap extends StatefulWidget {
  final int? typeView;
  final Widget? header;
  final bool? loading;
  final List<Vendor>? vendors;
  final VendorStore? vendorStore;
  final ScrollController? controller;
  final bool enableRating;

  const LayoutMap({
    Key? key,
    this.typeView,
    this.header,
    this.loading,
    this.vendorStore,
    this.vendors,
    this.controller,
    this.enableRating = true,
  }) : super(key: key);

  @override
  State<LayoutMap> createState() => _LayoutMapState();
}

class _LayoutMapState extends State<LayoutMap> with LoadingMixin {
  late GoogleMapController _controller;

  Map<String, Marker> _marker = {};

  double top = 0.7;

  @override
  void didChangeDependencies() {
    if (widget.vendors != null) {
      setMarker(widget.vendors!);
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant LayoutMap oldWidget) {
    if (widget.vendors != oldWidget.vendors) {
      setMarker(widget.vendors!);
    }
    super.didUpdateWidget(oldWidget);
  }

  void setMarker(List<Vendor> vendors) async {
    Map<String, Marker> markers = {};
    for (int i = 0; i < widget.vendors!.length; i++) {
      Vendor vendor = widget.vendors![i];
      String id = '${vendor.id}';

      if (vendor.location != null) {
        BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(60, 60), devicePixelRatio: 4),
          'assets/images/marker.png',
        );
        markers.addAll({
          id: Marker(
            markerId: MarkerId(id),
            position: LatLng(vendor.location!.lat!, vendor.location!.lng!),
            infoWindow: InfoWindow(
              title: vendor.storeName,
              snippet: vendor.vendorAddress,
            ),
            icon: icon,
            anchor: const Offset(0.5, 0.5),
          ),
        });
      }
    }
    setState(() {
      _marker = markers;
    });
  }

  void goVendor(Vendor vendor) async {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(vendor.location!.lat!, vendor.location!.lng!),
      zoom: initZoom,
    )));
    _controller.showMarkerInfoWindow(MarkerId('${vendor.id}'));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AuthStore authStore = Provider.of<AuthStore>(context);

    String view = widget.typeView == 1
        ? 'grid'
        : widget.typeView == 3
            ? 'list'
            : 'carousel';

    double paddingBottomCarousel = MediaQuery.of(context).padding.bottom;
    return Observer(builder: (_) {
      UserLocation location = authStore.locationStore.location;
      LatLng initVisit = location.lat is double && location.lng is double
          ? LatLng(location.lat!, location.lng!)
          : const LatLng(initLat, initLng);
      Map<String, Marker> markers = {
        '0': Marker(
          markerId: const MarkerId('0'),
          position: initVisit,
          infoWindow: const InfoWindow(
            title: '',
          ),
        ),
        ..._marker,
      };

      return Theme(
        data: theme.copyWith(
          bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
        ),
        child: Scaffold(
          bottomSheet: view == 'carousel'
              ? Container(
                  key: Key('${widget.typeView}'),
                  margin: EdgeInsets.only(bottom: paddingBottomCarousel),
                  child: builderView(
                    context,
                    vendors: widget.vendors,
                    view: view,
                    type: widget.typeView,
                  ),
                )
              : null,
          body: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initVisit,
                    zoom: initZoom,
                  ),
                  myLocationButtonEnabled: false,
                  markers: markers.values.toSet(),
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      _controller = controller;
                    });
                  },
                ),
              ),
              Positioned(
                top: 44,
                left: 20,
                right: 20,
                child: Container(
                  padding: paddingHorizontalTiny,
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    boxShadow: initBoxShadow,
                  ),
                  child: widget.header,
                ),
              ),
              if (view != 'carousel')
                NotificationListener<DraggableScrollableNotification>(
                  key: Key('${widget.typeView}'),
                  onNotification: (notification) {
                    setState(() {
                      top = 1 - notification.extent;
                    });
                    return true;
                  },
                  child: DraggableScrollableActuator(
                    child: DraggableScrollableSheet(
                      expand: true,
                      initialChildSize: 0.3,
                      minChildSize: 0.3,
                      maxChildSize: 0.85,
                      builder: (
                        BuildContext context,
                        ScrollController scrollController,
                      ) {
                        return Container(
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            boxShadow: initBoxShadow,
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: SafeArea(
                            top: false,
                            child: CustomScrollView(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              slivers: [
                                SliverPersistentHeader(
                                  pinned: true,
                                  floating: true,
                                  delegate: StickyTabBarDelegate(
                                    child: Container(
                                      height: 24,
                                      color: theme.scaffoldBackgroundColor,
                                      child: Center(
                                        child: Container(
                                          height: 4,
                                          width: 51,
                                          decoration: BoxDecoration(
                                            color: theme.dividerColor,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    height: 32,
                                  ),
                                ),
                                CupertinoSliverRefreshControl(
                                  onRefresh: widget.vendorStore!.refresh,
                                  builder: buildAppRefreshIndicator,
                                ),
                                SliverToBoxAdapter(
                                  child: builderView(
                                    context,
                                    vendors: widget.vendors,
                                    view: view,
                                    type: widget.typeView,
                                  ),
                                ),
                                if (widget.loading!)
                                  SliverToBoxAdapter(
                                    child: buildLoading(context, isLoading: widget.vendorStore!.canLoadMore),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget builderView(BuildContext context, {List<Vendor>? vendors, String? view, int? type}) {
    ThemeData theme = Theme.of(context);

    String template = Strings.vendorItemGradient;
    double pad = 16;
    dynamic padding = paddingHorizontal.add(paddingVerticalLarge);
    Color colorItem = theme.colorScheme.surface;
    double widthBanner = 262;
    double heightBanner = 180;

    switch (widget.typeView) {
      case 1:
        template = Strings.vendorItemContained;
        padding = paddingHorizontal.copyWith(bottom: itemPaddingLarge);
        break;
      case 2:
        template = Strings.vendorItemEmerge;
        padding = paddingHorizontal.add(paddingVerticalLarge);
        colorItem = theme.scaffoldBackgroundColor;
        widthBanner = 270;
        heightBanner = 174;
        break;

      case 3:
        template = Strings.vendorItemHorizontal;
        pad = 8;
        padding = paddingHorizontal.copyWith(bottom: itemPaddingLarge);
        break;
    }

    switch (view) {
      case 'list':
        return ViewList(
          length: vendors!.length,
          padding: padding,
          pad: pad,
          buildItem: ({required int index, double? widthItem}) {
            return buildItem(
              vendor: vendors.elementAt(index),
              widthItem: widthItem,
              template: template,
              color: colorItem,
              widthBanner: widthBanner,
              heightBanner: heightBanner,
            );
          },
        );
      case 'grid':
        return ViewGrid(
          length: vendors!.length,
          padding: padding,
          pad: pad,
          buildItem: ({required int index, double? widthItem}) {
            return buildItem(
              vendor: vendors.elementAt(index),
              widthItem: widthItem,
              template: template,
              color: colorItem,
              widthBanner: widthBanner,
              heightBanner: heightBanner,
            );
          },
        );
      default:
        return ViewCarousel(
          length: vendors!.length,
          padding: padding,
          pad: pad,
          buildItem: ({required int index, double? widthItem}) {
            return buildItem(
              vendor: vendors.elementAt(index),
              widthItem: widthItem,
              template: template,
              color: colorItem,
              widthBanner: widthBanner,
              heightBanner: heightBanner,
            );
          },
        );
    }
  }

  Widget buildItem(
      {Vendor? vendor, double? widthItem, String? template, Color? color, double? widthBanner, double? heightBanner}) {
    return CirillaVendorItem(
      vendor: vendor,
      template: template,
      widthItem: widthItem,
      color: color,
      widthBanner: widthBanner,
      heightBanner: heightBanner,
      directionIcon: vendor != null && vendor.location != null ? buildIconDirection(context, vendor: vendor) : null,
      enableDistance: true,
    );
  }

  Widget buildIconDirection(BuildContext context, {Vendor? vendor}) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (vendor != null) {
          goVendor(vendor);
        }
      },
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(FeatherIcons.navigation, color: theme.primaryColor, size: 14),
      ),
    );
  }
}
