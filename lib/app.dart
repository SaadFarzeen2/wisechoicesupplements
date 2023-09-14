import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'top.dart';

import 'constants/strings.dart';
import 'constants/languages.dart';
import 'mixins/mixins.dart';
import 'routes.dart';
import 'service/service.dart';
import 'store/store.dart';
import 'utils/utils.dart';

class MyApp extends StatelessWidget with Utility, ThemeMixin {
  final GlobalKey<NavigatorState> _rootNav = GlobalKey<NavigatorState>();

  final PersistHelper persistHelper;
  final RequestHelper requestHelper;

  final SettingStore _settingStore;

  MyApp({Key? key, required this.requestHelper, required this.persistHelper})
      : _settingStore = SettingStore(persistHelper, requestHelper),
        super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<RequestHelper>(create: (_) => requestHelper),
          Provider<AppStore>(create: (_) => AppStore()),
          Provider<AuthStore>(create: (_) => AuthStore(persistHelper, requestHelper)),
          Provider<SettingStore>(create: (_) => _settingStore),
          Provider<ProductCategoryStore>(create: (_) => ProductCategoryStore(requestHelper, persistHelper, parent: 0)),
        ],
        child: Consumer<SettingStore>(
          builder: (_, store, __) => Observer(
            builder: (_) => MaterialApp(
              navigatorKey: _rootNav,
              navigatorObservers: <NavigatorObserver>[observer],
              scrollBehavior: CustomScrollBehavior(),
              debugShowCheckedModeBanner: false,
              title: Strings.appName,
              initialRoute: '/',
              theme: buildTheme(store),
              routes: Routes.routes(store),
              onGenerateRoute: (settings) => Routes.onGenerateRoute(settings, store),
              // onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
              locale: LANGUAGES[store.locale] ?? Locale.fromSubtags(languageCode: store.locale),
              supportedLocales: store.supportedLanguages
                  .map((language) => LANGUAGES[language.locale!] ?? Locale.fromSubtags(languageCode: language.locale!))
                  .toList(),
              localizationsDelegates: const [
                // A class which loads the translations from JSON files
                AppLocalizations.delegate,
                // Built-in localization of basic text for Material widgets
                GlobalMaterialLocalizations.delegate,
                // Built-in localization for text direction LTR/RTL
                GlobalWidgetsLocalizations.delegate,

                GlobalCupertinoLocalizations.delegate,
              ],
              // Returns a locale which will be used by the app
              localeResolutionCallback: (locale, supportedLocales) =>
                  // Check if the current device locale is supported
                  supportedLocales.firstWhere((supportedLocale) => supportedLocale.languageCode == locale?.languageCode,
                      orElse: () => supportedLocales.first),
            ),
          ),
        ),
      );
}
