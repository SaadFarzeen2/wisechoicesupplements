import 'dart:convert';
import 'dart:developer';

import 'package:cirilla/constants/app.dart' as app_configs;
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'setting_store.g.dart';

class SettingStore = SettingStoreBase with _$SettingStore;

List<Language> defaultLanguageSupport = app_configs.languageSupport
    .map(
      (code) => Language(
        code: code,
        locale: code,
        language: getLanguages[code.split('-')[0]]['name'],
      ),
    )
    .toList();

abstract class SettingStoreBase with Store {
  final PersistHelper _persistHelper;
  final RequestHelper _requestHelper;

  SettingStoreBase(this._persistHelper, this._requestHelper) {
    init();
  }

  void init() async {
    await restore();
    await getSetting();
    _loading = false;
  }

  Future<void> restore() async {
    _darkMode = await _persistHelper.getDarkMode();
    _locale = await _persistHelper.getLanguage();

    String? currency = await _persistHelper.getCurrency();
    if (currency != null && currency != '') {
      _currency = currency;
    }

    _enableGetStart = await _persistHelper.getEnableGetStart();
    _enableSelectLanguage = await _persistHelper.getEnableSelectLanguage();
    _enableAllowLocation = await _persistHelper.getEnableAllowLocation();

    String? settings = _persistHelper.getSettings();
    if (settings != null && settings != '') {
      setSetting(jsonDecode(settings));
      _loading = false;
    }
  }

  // Store variables: --------------------------------------------------------------------------------------------------
  @observable
  ObservableList<Language> _supportedLanguages =
      ObservableList<Language>.of(defaultLanguageSupport);

  // Default language
  @observable
  String _lang = app_configs.defaultLanguage;

  @observable
  String _locale = app_configs.defaultLanguage;

  @observable
  bool _darkMode = false;

  @observable
  bool _loading = true;

  @observable
  ObservableList<String?> tabs =
      ObservableList<String?>.of([Strings.tabActive]);

  @observable
  DataScreen? _data;

  // Currency
  @observable
  ObservableMap<String, dynamic> _currencies =
      ObservableMap<String, dynamic>.of({});

  // Default currency
  @observable
  String? _defaultCurrency;

  @observable
  String? _currency;

  @observable
  String? _checkoutUrl = '';

  @observable
  bool _enableGetStart = true;

  @observable
  bool _enableSelectLanguage = true;

  @observable
  bool _enableAllowLocation = true;

  @observable
  bool _enableUsingBiometric = false;

  // Computed: ---------------------------------------------------------------------------------------------------------
  @computed
  bool get darkMode => _darkMode;

  @computed
  String get themeModeKey => _darkMode ? 'dark' : 'value';

  @computed
  String get languageKey => _lang == _locale ? 'text' : _locale;

  @computed
  String get imageKey => _lang == _locale ? 'src' : _locale;

  @computed
  String get locale => _locale;

  @computed
  ObservableList<Language> get supportedLanguages => _supportedLanguages;

  @computed
  bool get loading => _loading;

  @computed
  PersistHelper get persistHelper => _persistHelper;

  @computed
  RequestHelper get requestHelper => _requestHelper;

  @computed
  String? get defaultCurrency => _defaultCurrency;

  @computed
  String? get currency => _currency;

  @computed
  bool get isCurrencyChanged => _currency != _defaultCurrency;

  @computed
  ObservableMap<String, dynamic> get currencies => _currencies;

  @computed
  String? get checkoutUrl => _checkoutUrl;

  // Get data screen
  @computed
  DataScreen? get data => _data;

  @computed
  bool get enableGetStart => _enableGetStart;

  @computed
  bool get enableSelectLanguage => _enableSelectLanguage;

  @computed
  bool get enableAllowLocation => _enableAllowLocation;

  @computed
  bool get enableUsingBiometric => _enableUsingBiometric;

  // Actions: ----------------------------------------------------------------------------------------------------------
  @action
  void setTab(String? tab) {
    if (tabs.isEmpty || tabs[tabs.length - 1] != tab) {
      tabs.add(tab);
    }
  }

  @action
  removeTab() {
    if (tabs.length > 1) return tabs.removeLast();
    return true;
  }

  @action
  Future<void> changeLanguage(String value) async {
    _locale = value;
    await _persistHelper.saveLanguage(value);
  }

  @action
  Future<void> changeCurrency(String value) async {
    _currency = value;
    await _persistHelper.saveCurrency(value);
  }

  @action
  Future<void> setDarkMode({required bool value}) async {
    await _persistHelper.saveDarkMode(value);
    _darkMode = value;
  }

  @action
  Future<void> closeGetStart() async {
    await _persistHelper.saveEnableGetStart(false);
    _enableGetStart = false;
  }

  @action
  Future<void> closeSelectLanguage() async {
    await _persistHelper.saveEnableSelectLanguage(false);
    _enableSelectLanguage = false;
  }

  @action
  Future<void> closeAllowLocation() async {
    await _persistHelper.saveEnableAllowLocation(false);
    _enableAllowLocation = false;
  }

  @action
  Future<void> setBiometric({required bool value}) async {
    await _persistHelper.saveUsingBiometric(value);
    _enableUsingBiometric = value;
  }

  @action
  Future<void> getBiometric() async {
    _enableUsingBiometric = _persistHelper.getUsingBiometric();
  }

  @action
  Future<void> getSetting() async {
    String? persistSettings = _persistHelper.getSettings();
    try {
      Map<String, dynamic> settings = await _requestHelper.getSettings();
      // log(settings.toString());

      String json = jsonEncode(settings);
      if (persistSettings != json) {
        await _persistHelper.saveSettings(json);
      }
      setSetting(settings);
    } catch (e) {
      log(e.toString());
      avoidPrint(e);
    }
  }

  @action
  void setSetting(json) {
    // Screens setting
    if (json['data'] != null && json['data'].length > 0)
      _data = DataScreen.fromJson(json['data']);

    // Languages setting
    _lang = json['language'];
    if (json['languages'] != null && json['languages'].length > 0) {
      List<Language> languages = json['languages']
          .keys
          .map((key) {
            final language = json['languages'][key];
            String code = language['code'] ?? language['language_code'];
            return Language(
                code: code.toUpperCase(),
                locale: code,
                language: language['native_name']);
          })
          .toList()
          .cast<Language>();
      _supportedLanguages = ObservableList<Language>.of(languages);
    }

    // Currency setting
    _defaultCurrency = json['currency'];
    _currency ??= json['currency'];
    if (json['currencies'] != null)
      _currencies = ObservableMap<String, dynamic>.of(json['currencies']);

    // Checkout url
    if (json['checkout_url'] != null && json['checkout_url'] is String)
      _checkoutUrl = json['checkout_url'];
  }
}
