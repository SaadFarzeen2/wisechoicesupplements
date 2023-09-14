import 'package:flutter/material.dart';

import 'package:feather_icons/feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:ui/notification/notification_screen.dart';

import 'widgets/layout_default.dart';
import 'widgets/layout_map.dart';
import 'widgets/sort.dart';
import 'widgets/refine.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({Key? key}) : super(key: key);

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen>
    with ShapeMixin, Utility, AppBarMixin, HeaderListMixin, NavigationMixin {
  final ScrollController _controller = ScrollController();
  VendorStore? _vendorStore;
  SettingStore? _settingStore;
  AuthStore? _authStore;
  int typeView = 0;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);

    WidgetConfig? widgetConfig = _settingStore!.data!.screens!['vendorList'] != null
        ? _settingStore!.data!.screens!['vendorList']!.widgets!['vendorListPage']
        : null;
    String lang = _settingStore?.locale ?? defaultLanguage;
    int itemPerPage =
        widgetConfig != null ? ConvertData.stringToInt(get(widgetConfig.fields, ['itemPerPage'], 10), 10) : 10;

    _vendorStore = VendorStore(
      _settingStore!.requestHelper,
      perPage: itemPerPage,
      lang: lang,
      sort: {
        'key': 'vendor_list_date_asc',
        'query': {
          'orderby': 'date',
          'order': 'asc',
        },
      },
      locationStore: _authStore?.locationStore,
    );
    _vendorStore!.getVendors();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (!_controller.hasClients || _vendorStore!.loading || !_vendorStore!.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _vendorStore!.getVendors();
    }
  }

  void _onChange(int value) {
    setState(() {
      typeView = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    TranslateType translate = AppLocalizations.of(context)!.translate;


    WidgetConfig? widgetConfig = _settingStore!.data!.screens!['vendorList'] != null
        ? _settingStore!.data!.screens!['vendorList']!.widgets!['vendorListPage']
        : null;
    Map<String, dynamic>? configs = _settingStore!.data!.screens!['vendorList'] != null
        ? _settingStore!.data!.screens!['vendorList']!.configs
        : null;
    String? layout = widgetConfig != null ? widgetConfig.layout : 'default';
    bool enableRangeFilter = widgetConfig != null ? get(widgetConfig.fields, ['enableRangeFilter'], false) : false;

    bool enableRating = widgetConfig != null ? get(widgetConfig.fields, ['enableRating'], true) : true;
    bool? enableCenterTitle = get(configs, ['enableCenterTitle'], true);

    return Observer(builder: (_) {
      bool loading = _vendorStore!.loading;
      List<Vendor> vendors = _vendorStore!.vendors;
      List<Vendor> emptyVendor = List.generate(_vendorStore!.perPage, (index) => Vendor());
      bool isShimmer = _vendorStore!.vendors.isEmpty && loading;

      if (_vendorStore!.vendors.isEmpty && !loading) {
        return Scaffold(
          body: SafeArea(
            child: _buildVendorsEmpty(context, textTheme),
          ),
          appBar: AppBar(
            title: Text(translate('vendor_list_txt'), style: theme.appBarTheme.titleTextStyle),
            centerTitle: enableCenterTitle,
          ),
        );
      }

      switch (layout) {
        case 'map':
          return LayoutMap(
            header: buildHeader(context, _vendorStore, enableRangeFilter),
            typeView: typeView,
            loading: loading,
            vendors: loading ? emptyVendor : vendors,
            vendorStore: _vendorStore,
            controller: _controller,
            enableRating: enableRating,
          );
        default:
          return LayoutDefault(
            header: buildHeader(context, _vendorStore, enableRangeFilter),
            typeView: typeView,
            loading: loading,
            vendors: isShimmer ? emptyVendor : vendors,
            vendorStore: _vendorStore,
            controller: _controller,
            configs: configs,
            enableRating: enableRating,
          );
      }
    });
  }

  Widget buildHeader(BuildContext context, VendorStore? vendorStore, bool enableRangeFilter) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return buildBoxHeader(
      context,
      color: Colors.transparent,
      paddingHorizontal: 0,
      left: Row(
        children: [
          buildButtonIcon(
            context,
            icon: FeatherIcons.barChart2,
            title: translate('product_list_sort'),
            onPressed: () async {
              Map<String, dynamic>? sort = await showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  // Using Wrap makes the bottom sheet height the height of the content.
                  // Otherwise, the height will be half the height of the screen.
                  return Sort(
                    sort: vendorStore!.sort,
                  );
                },
              );
              if (sort != null) {
                _vendorStore!.onChanged(sort: sort);
              }
            },
          ),
          const SizedBox(width: 8),
          buildButtonIcon(
            context,
            icon: FeatherIcons.sliders,
            title: translate('product_list_refine'),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  // Using Wrap makes the bottom sheet height the height of the content.
                  // Otherwise, the height will be half the height of the screen.
                  return Refine(
                    search: vendorStore!.search,
                    rangeDistance: vendorStore.rangDistance,
                    categories: vendorStore.categories,
                    enableRange: enableRangeFilter,
                    onSubmit: (String search, double? rangeDistance, List<ProductCategory>? categories) {
                      vendorStore.onChanged(
                        search: search,
                        rangeDistance: rangeDistance,
                        categories: categories,
                        enableEmptyCategory: true,
                      );
                      Navigator.pop(context);
                      vendorStore.refresh();
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      right: buildGroupButtonIcon(
        context,
        icons: [FeatherIcons.airplay, FeatherIcons.grid, FeatherIcons.square, FeatherIcons.list],
        visitSelect: typeView,
        onChange: _onChange,
      ),
    );
  }

  Widget _buildVendorsEmpty(BuildContext context, TextTheme textTheme) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return NotificationScreen(
      title: Text(translate('All Vendors'), style: textTheme.titleLarge),
      content: Text(
        translate('vendor_detail_empty_description'),
        style: textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      iconData: FeatherIcons.shoppingCart,
      textButton: Text(translate('cart_return_shop')),
      styleBtn: ElevatedButton.styleFrom(padding: paddingHorizontalLarge),
      onPressed: () => navigate(context, {
        "type": "tab",
        "router": "/",
        "args": {"key": "screens_category"}
      }),
    );
  }
}
