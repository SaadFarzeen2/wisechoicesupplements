import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/product_list/widgets/filter_list.dart';
import 'package:cirilla/screens/product_list/widgets/heading_list.dart';
import 'package:cirilla/screens/product_list/widgets/product_list.dart';
import 'package:cirilla/screens/product_list/widgets/refine.dart';
import 'package:cirilla/screens/vendor/vendor_info.dart';
import 'package:cirilla/store/product/filter_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ui/notification/notification_screen.dart';
import 'package:ui/tab/sticky_tab_bar_delegate.dart';

import 'widgets/about.dart';
import 'widgets/coupon.dart';
import 'widgets/polices.dart';
import 'widgets/review.dart';

import 'widgets/tab.dart';

class VendorScreen extends StatefulWidget {
  static const String routeName = '/vendor';

  const VendorScreen({Key? key, this.args, this.store}) : super(key: key);

  final Map? args;
  final SettingStore? store;

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> with AppBarMixin, LoadingMixin, NavigationMixin {
  Vendor? _vendor;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    Vendor? vendor = widget.args!['vendor'] is Vendor ? widget.args!['vendor'] : Vendor();

    if (vendor is Vendor && vendor.id != null) {
      setState(() {
        _loading = false;
        _vendor = vendor;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (_loading) {
      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate('vendor_detail_txt')),
        body: Center(
          child: buildLoading(context, isLoading: _loading),
        ),
      );
    }
    if (_vendor is Vendor) {
      return VendorDataScreen(
        vendor: _vendor!,
        store: widget.store,
      );
    }
    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('vendor_detail_txt')),
      body: Center(
        child: NotificationScreen(
          iconData: FeatherIcons.bookmark,
          title: SizedBox(
            width: 147,
            child: Text(
              translate('vendor_detail_txt'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          content: SizedBox(
            width: 220,
            child: Text(
              translate('vendor_detail_empty_description'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          styleBtn: ElevatedButton.styleFrom(padding: paddingHorizontalLarge),
          textButton: Text(translate('vendor_detail_empty_button')),
          onPressed: () => navigate(context, {
            "type": "tab",
            "router": "/",
            "args": {"key": "screens_home"}
          }),
        ),
      ),
    );
  }
}

class VendorDataScreen extends StatefulWidget {
  const VendorDataScreen({Key? key, required this.vendor, this.store}) : super(key: key);

  final Vendor vendor;
  final SettingStore? store;

  @override
  State<VendorDataScreen> createState() => _VendorDataScreenState();
}

class _VendorDataScreenState extends State<VendorDataScreen>
    with Utility, SnackMixin, LoadingMixin, AppBarMixin, SingleTickerProviderStateMixin, ShapeMixin, ProductListMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();
  TabController? _tabController;
  // List<String> tabs = ['products', 'coupons', 'about', 'reviews', 'polices'];
  List<String> tabs = ['products', 'about'];
  String _visitTab = 'products';

  // for products tab
  late ProductsStore _productsStore;
  FilterStore? _filterStore;
  int typeViewProduct = 0;
  VendorStore? _vendorStore;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _tabController = TabController(vsync: this, length: tabs.length);

    _productsStore = ProductsStore(
      widget.store!.requestHelper,
      perPage: 10,
      vendor: widget.vendor,
      currency: widget.store!.currency,
      language: widget.store!.locale,
    );
    _filterStore = FilterStore(widget.store!.requestHelper, language: widget.store!.locale);
    _vendorStore = VendorStore(
      widget.store!.requestHelper,
      lang: widget.store!.locale,
    )..getIdCategory(widget.vendor.id ?? 0);
    init();
  }

  void _onScroll() {
    if (_visitTab == 'products') {
      if (!_controller.hasClients || _productsStore.loading || !_productsStore.canLoadMore) return;
      final thresholdReached = _controller.position.extentAfter < 10;
      if (thresholdReached) {
        _productsStore.getProducts();
      }
    }
  }

  void _onChanged(String visitTab) {
    setState(() {
      _visitTab = visitTab;
    });
  }

  void _onChangedTypeViewProduct(int value) {
    setState(() {
      typeViewProduct = value;
    });
  }

  Future<void> init() async {
    await _productsStore.getProducts();
    await _filterStore!.getAttributes();
    await _filterStore!.getMinMaxPrices();
  }

  void _clearAll() {
    _filterStore!.onChange(
      inStock: _productsStore.filter!.inStock,
      onSale: _productsStore.filter!.onSale,
      featured: _productsStore.filter!.featured,
      category: _productsStore.filter!.category,
      attributeSelected: _productsStore.filter!.attributeSelected,
      productPrices: _productsStore.filter!.productPrices,
      rangePrices: _productsStore.filter!.rangePrices,
    );
  }

  void onSubmit(FilterStore? filter) {
    if (filter != null) {
      _productsStore.onChanged(filterStore: filter);
    } else {
      _clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    WidgetConfig? widgetConfig = widget.store!.data!.screens!['vendorDetail'] != null
        ? widget.store!.data!.screens!['vendorDetail']!.widgets!['vendorDetailPage']
        : null;
    Map<String, dynamic>? configs = widget.store!.data!.screens!['vendorDetail'] != null
        ? widget.store!.data!.screens!['vendorDetail']!.configs
        : null;

    bool enableCenterTitle = get(configs, ['enableCenterTitle'], true);
    Map? fields = widgetConfig != null ? widgetConfig.fields : {};
    String viewAppbar = get(fields, ['typeAppBar'], 'emerge');

    bool enableRating = widgetConfig != null ? get(widgetConfig.fields, ['enableRating'], true) : true;

    Vendor vendor = widget.vendor;
    String refinePosition = Strings.refinePositionBottom;
    String refineItemStyle = Strings.refineItemStyleListTitle;

    return Scaffold(
      key: _scaffoldKey,
      bottomSheet: _visitTab == 'reviews' ? const BottomWriteReview() : null,
      drawer: Drawer(
        child: buildRefine(context, min: 1, refinePosition: refinePosition, refineItemStyle: refineItemStyle),
      ),
      endDrawer: Drawer(
        child: buildRefine(context, min: 1, refinePosition: refinePosition, refineItemStyle: refineItemStyle),
      ),
      body: Observer(
        builder: (_) {
          ProductsStore productsStore = _productsStore;
          return CustomScrollView(
            controller: _controller,
            slivers: [
              VendorInfo(
                viewAppbar: viewAppbar,
                vendor: vendor,
                enableCenterTitle: enableCenterTitle,
                enableRating: enableRating,
              ),
              TabWidget(
                tabs: tabs,
                translate: translate,
                controller: _tabController,
                onChanged: _onChanged,
              ),
              ...childrenTab(
                _visitTab,
                vendor: vendor,
                productStore: productsStore,
                refinePosition: refinePosition,
                refineItemStyle: refineItemStyle,
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> childrenTab(
    String visitTab, {
    Vendor? vendor,
    required ProductsStore productStore,
    String refinePosition = Strings.refinePositionBottom,
    String refineItemStyle = Strings.refineItemStyleListTitle,
  }) {
    bool loading = productStore.loading;
    List<Product> products = productStore.products;
    switch (visitTab) {
      case 'coupons':
        return [
          const SliverPadding(
            padding: paddingHorizontal,
            sliver: SliverToBoxAdapter(
              child: CouponWidget(),
            ),
          )
        ];
      case 'about':
        return [
          SliverPadding(
            padding: paddingHorizontal,
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                child: AboutWidget(vendor: vendor),
              ),
            ),
          )
        ];
      case 'reviews':
        return [
          const SliverPadding(
            padding: paddingHorizontal,
            sliver: SliverToBoxAdapter(
              child: BasicReview(),
            ),
          ),
          SliverPadding(
            padding: paddingHorizontal.copyWith(bottom: 66),
            sliver: const SliverToBoxAdapter(
              child: ReviewList(),
            ),
          ),
        ];
      case 'polices':
        return [
          const SliverPadding(
            padding: paddingHorizontal,
            sliver: SliverToBoxAdapter(
              child: PolicesWidget(),
            ),
          ),
        ];
      default:
        bool isShimmer = products.isEmpty && loading;
        List<Product> emptyProduct = List.generate(productStore.perPage, (index) => Product()).toList();
        return [
          SliverPersistentHeader(
            pinned: false,
            floating: true,
            delegate: StickyTabBarDelegate(
              child: HeadingList(
                height: 56,
                sort: productStore.sort,
                onchangeSort: (Map sort) => productStore.onChanged(sort: sort),
                clickRefine: () async {
                  if (refinePosition == Strings.refinePositionLeft) {
                    _scaffoldKey.currentState!.openDrawer();
                  } else if (refinePosition == Strings.refinePositionRight) {
                    _scaffoldKey.currentState!.openEndDrawer();
                  } else {
                    showModalBottomSheet<FilterStore>(
                      isScrollControlled: true,
                      context: context,
                      shape: borderRadiusTop(),
                      builder: (context) =>
                          buildRefine(context, refinePosition: refinePosition, refineItemStyle: refineItemStyle),
                    );
                  }
                },
                typeView: typeViewProduct,
                onChangeType: _onChangedTypeViewProduct,
              ),
              height: 58,
            ),
          ),
          FilterList(
            productsStore: productStore,
            filter: _filterStore,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: productStore.refresh,
            builder: buildAppRefreshIndicator,
          ),
          SliverPadding(
            padding: paddingHorizontal.copyWith(top: itemPaddingLarge),
            sliver: ProductListLayout(
              products: isShimmer ? emptyProduct : productStore.products.where(productCatalog).toList(),
              typeView: typeViewProduct,
              // styles: widget.styles,
            ),
          ),
          if (loading)
            SliverToBoxAdapter(
              child: buildLoading(context, isLoading: productStore.canLoadMore),
            ),
        ];
    }
  }

  Widget buildRefine(
    BuildContext context, {
    double min = 0.8,
    String refinePosition = Strings.refinePositionBottom,
    String refineItemStyle = Strings.refineItemStyleListTitle,
  }) {
    return Observer(builder: (_) {
      return Refine(
        filterStore: _filterStore,
        includeCategory: _vendorStore?.categoryVendors,
        clearAll: _clearAll,
        onSubmit: onSubmit,
        min: min,
        refineItemStyle: refineItemStyle,
        refinePosition: refinePosition,
      );
    });
  }
}
