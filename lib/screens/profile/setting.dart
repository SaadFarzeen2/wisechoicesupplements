import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'clear_cache.dart';
import 'widgets/modal_currency.dart';
import 'widgets/modal_language.dart';

class SettingScreen extends StatefulWidget {
  static const String routeName = '/profile/setting';

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with AppBarMixin {
  SettingStore? _settingStore;
  AuthStore? _authStore;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore ??= Provider.of<AuthStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    _settingStore!.getBiometric();
  }

  void onClickLanguage() {
    if (_settingStore!.supportedLanguages.length == 1) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        TranslateType translate = AppLocalizations.of(context)!.translate;
        return buildViewModal(
            title: translate('app_settings_language'), child: ModalLanguage(settingStore: _settingStore));
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
    );
  }

  void onClickCurrency() {
    List<Currency> currencies = _settingStore!.currencies.keys
        .map(
          (key) => Currency(
            code: key,
            name: key,
            symbol: _settingStore!.currencies[key]['symbol'],
          ),
        )
        .toList()
        .cast<Currency>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        TranslateType translate = AppLocalizations.of(context)!.translate;
        return buildViewModal(
          title: translate('select_country'),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return ModalCurrency(
                currencies: currencies,
                value: _settingStore!.currency,
                onChange: (String? value) {
                  _settingStore!.changeCurrency(value!);
                },
              );
            },
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
    );
  }

  Widget buildViewModal({required String title, Widget? child}) {
    ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: height / 2),
      padding: paddingHorizontal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: itemPaddingMedium, bottom: itemPaddingLarge),
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
          Flexible(child: SingleChildScrollView(child: child))
        ],
      ),
    );
  }

  String? getCodeLanguage() {
    int indexSelect =
        _settingStore!.supportedLanguages.indexWhere((element) => element.locale == _settingStore!.locale);
    Language languageSelect = _settingStore!.supportedLanguages[indexSelect > 0 ? indexSelect : 0];
    return languageSelect.code;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    WidgetConfig widgetConfig = _settingStore!.data!.screens!['profile']!.widgets!['profilePage']!;
    Map<String, dynamic>? fields = widgetConfig.fields;
    bool enableChangeTheme = get(fields, ['enableChangeTheme'], true);
    bool enableUsingBiometric = get(fields, ['enableUsingBiometric'], true);

    if (enableUsingBiometric == false) {
      _settingStore!.setBiometric(value: false);
    }

    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('app_settings')),
      body: Observer(
        builder: (_) => ListView(
          padding: paddingHorizontal,
          children: [
            CirillaTile(
              title: Text(translate('app_settings_language'), style: theme.textTheme.titleSmall),
              trailing: Text(getCodeLanguage()!, style: theme.textTheme.bodyLarge),
              onTap: () => onClickLanguage(),
            ),
            if (_settingStore!.currencies.length > 1)
              CirillaTile(
                title: Text(translate('app_settings_currency'), style: theme.textTheme.titleSmall),
                trailing: Text(_settingStore!.currency!, style: theme.textTheme.bodyLarge),
                onTap: () => onClickCurrency(),
              ),
            if (enableChangeTheme)
              CirillaTile(
                title: Text(translate('app_settings_dark_theme'), style: theme.textTheme.titleSmall),
                trailing: CupertinoSwitch(
                  value: _settingStore!.darkMode,
                  onChanged: (value) => _settingStore!.setDarkMode(value: value),
                ),
                isChevron: false,
              ),
            if (_authStore?.isLogin == true && enableUsingBiometric)
              CirillaTile(
                title: Text(translate('login_local_using_biometric'), style: theme.textTheme.titleSmall),
                trailing: CupertinoSwitch(
                  value: _settingStore!.enableUsingBiometric,
                  onChanged: (value) => _settingStore!.setBiometric(value: value),
                ),
                isChevron: false,
              ),
            const ClearCache(),
          ],
        ),
      ),
    );
  }
}
