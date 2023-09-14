import 'dart:async';

import 'package:cirilla/screens/no_internet/no_internet_mixin.dart';
import 'package:cirilla/service/messaging.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:provider/provider.dart';

import 'widgets/drawer.dart';
import 'widgets/tab_home.dart';
import 'widgets/tabs.dart';
import 'widgets/empty.dart';

/// Static screens
Map<String, Widget> widgetOptions = {
  'screens_home': const TabHome(),
  "screens_category": const ProductCategoryScreen(),
  "screens_wishlist": const WishListScreen(),
  "screens_cart": const CartScreen(),
  "screens_profile": const ProfileScreen(),
  "screens_postCategory": const PostCategoryScreen(),
  "screens_postWishlist": const PostWishlistScreen(),
  "screens_vendorList": const VendorListScreen(),
};

/// Drawer screens
Map<String, dynamic> types = {
  'default': StyleState.overlay,
  'style1': StyleState.scaleRight,
  'style2': StyleState.scaleRight,
  'style3': StyleState.stack,
  'style4': StyleState.fixedStack,
  'style5': StyleState.scaleRight,
  'style6': StyleState.scaleRight,
  'style7': StyleState.rotate3dIn,
  'style8': StyleState.rotate3dOut,
  'style9': StyleState.popUp,
};

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  final SettingStore? store;
  final Map<String, dynamic>? args;

  const HomeScreen({Key? key, this.store, this.args}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Utility, MessagingMixin, NavigationMixin, NoInternetMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _drawerController = AwesomeDrawerBarController();
  late ProductCategoryStore _categoryStore;
  late AuthStore _authStore;
  // Internet Connection
  StreamSubscription<ConnectivityResult>? _subscription;
  Timer? _checkConnectionTimer;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    checkAndSubscribeConnection(
      context: context,
      subscription: _subscription,
      checkConnectionTimer: _checkConnectionTimer,
      autoCLoseTimer: _autoCloseTimer,
    );
    // Subscribe push notification
    subscribe(widget.store!.requestHelper, _navigate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Init store
    _categoryStore = Provider.of<ProductCategoryStore>(context);
    _authStore = Provider.of<AuthStore>(context);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _checkConnectionTimer?.cancel();
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  void _navigate(data) {
    navigate(context, data);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // Set transparent status bar on Android
    SystemUiOverlayStyle style = widget.store?.darkMode == true
        ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
        : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(theme.appBarTheme.systemOverlayStyle ?? style);

    return Stack(
      children: [
        widget.store!.data == null ? const Empty() : buildOnBoarding(context),
        SplashScreen(loading: widget.store!.loading),
      ],
    );
  }

  Widget buildOnBoarding(BuildContext context) {
    return Observer(
      builder: (_) {
        final WidgetConfig widgetConfig = widget.store!.data!.settings!['general']!.widgets!['general']!;

        bool isDisplay = widget.store?.enableGetStart ?? true;
        bool isLanguage = widget.store?.enableSelectLanguage ?? true;
        bool isAllowLocation = widget.store?.enableAllowLocation ?? true;
        bool enableSelectLanguage = get(widgetConfig.fields, ['enableSelectLanguage'], false);
        bool enableLocationScreen = get(widgetConfig.fields, ['enableLocationScreen'], false);
        bool enableOnBoarding = get(widgetConfig.fields, ['enableOnBoarding'], true);
        bool forceLogin = get(widgetConfig.fields, ['forceLogin'], false);
        bool forceLoginMobile = get(widgetConfig.fields, ['forceLoginMobile'], false);

        if (isLanguage && enableSelectLanguage) {
          return LanguageSetupScreen(store: widget.store);
        }

        if (isAllowLocation && enableLocationScreen) {
          return const AllowLocationScreen();
        }

        if (isDisplay && enableOnBoarding) {
          return OnBoardingScreen(store: widget.store);
        }

        if (forceLogin && !_authStore.isLogin) {
          return LoginScreen(store: widget.store);
        }

        if (forceLoginMobile && !_authStore.isLogin) {
          return LoginMobileScreen(contextType: 'login');
        }

        return buildHome(widget.store!.data);
      },
    );
  }

  Widget buildHome(DataScreen? data) {
    if (data == null) return Container();

    bool isRTL = (Directionality.of(context) == TextDirection.rtl);

    Map<String, Widget> newWidgetOptions = {}..addAll(widgetOptions);

    Data? tabsData = data.settings!['tabs'];
    Data sidebarData = data.settings!['sidebar']!;
    Data homeData = data.screens!['home']!;

    // Home Configs
    bool extendBody = get(homeData.configs, ['extendBody'], true);

    // Add custom tabs
    Map<String, Data> extraScreens = data.extraScreens!;
    extraScreens.forEach((key, value) {
      newWidgetOptions.putIfAbsent("extraScreens_$key", () => CustomScreen(screenKey: key));
    });

    // Drawer
    String? layout = sidebarData.widgets!['sidebar']!.layout;
    Color background = ConvertData.fromRGBA(
      get(sidebarData.widgets!['sidebar']!.styles, ['background', Provider.of<SettingStore>(context).themeModeKey]),
      Theme.of(context).canvasColor,
    );
    String scaleRotate = 'style2';
    String scaleBottom = 'style5';
    String scaleTop = 'style6';
    double angle = 0.0;
    double heightStyle = 0.0;

    if (scaleRotate == '$layout') {
      angle = -3.0;
    }
    if (scaleBottom == '$layout') {
      heightStyle = MediaQuery.of(context).size.height * (isRTL ? -0.19 : 0.19);
    }
    if (scaleTop == '$layout') {
      heightStyle = -MediaQuery.of(context).size.height * (isRTL ? -0.19 : 0.19);
    }
    List tabActive = widget.store!.tabs;

    return AwesomeDrawerBar(
      isRTL: isRTL,
      type: types['$layout'],
      controller: _drawerController,
      slideHeight: heightStyle,
      borderRadius: 24.0,
      backgroundColor: background,
      menuScreen: Sidebar(
        data: sidebarData,
        categories: _categoryStore.categories,
      ),
      showShadow: true,
      shadowColor: Theme.of(context).colorScheme.background,
      mainScreen: WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          extendBody: extendBody,
          bottomNavigationBar: Tabs(
            selected: tabActive.last,
            onItemTapped: widget.store!.setTab,
            data: tabsData,
          ),
          body: newWidgetOptions[tabActive.last],
        ),
        onWillPop: () async {
          return widget.store!.removeTab();
        },
      ),
      angle: angle,
      // openCurve: Curves.fastOutSlowIn,
      // closeCurve: Curves.bounceIn,
    );
  }
}
