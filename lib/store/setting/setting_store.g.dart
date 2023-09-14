// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingStore on SettingStoreBase, Store {
  Computed<bool>? _$darkModeComputed;

  @override
  bool get darkMode =>
      (_$darkModeComputed ??= Computed<bool>(() => super.darkMode,
              name: 'SettingStoreBase.darkMode'))
          .value;
  Computed<String>? _$themeModeKeyComputed;

  @override
  String get themeModeKey =>
      (_$themeModeKeyComputed ??= Computed<String>(() => super.themeModeKey,
              name: 'SettingStoreBase.themeModeKey'))
          .value;
  Computed<String>? _$languageKeyComputed;

  @override
  String get languageKey =>
      (_$languageKeyComputed ??= Computed<String>(() => super.languageKey,
              name: 'SettingStoreBase.languageKey'))
          .value;
  Computed<String>? _$imageKeyComputed;

  @override
  String get imageKey =>
      (_$imageKeyComputed ??= Computed<String>(() => super.imageKey,
              name: 'SettingStoreBase.imageKey'))
          .value;
  Computed<String>? _$localeComputed;

  @override
  String get locale => (_$localeComputed ??=
          Computed<String>(() => super.locale, name: 'SettingStoreBase.locale'))
      .value;
  Computed<ObservableList<Language>>? _$supportedLanguagesComputed;

  @override
  ObservableList<Language> get supportedLanguages =>
      (_$supportedLanguagesComputed ??= Computed<ObservableList<Language>>(
              () => super.supportedLanguages,
              name: 'SettingStoreBase.supportedLanguages'))
          .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: 'SettingStoreBase.loading'))
      .value;
  Computed<PersistHelper>? _$persistHelperComputed;

  @override
  PersistHelper get persistHelper => (_$persistHelperComputed ??=
          Computed<PersistHelper>(() => super.persistHelper,
              name: 'SettingStoreBase.persistHelper'))
      .value;
  Computed<RequestHelper>? _$requestHelperComputed;

  @override
  RequestHelper get requestHelper => (_$requestHelperComputed ??=
          Computed<RequestHelper>(() => super.requestHelper,
              name: 'SettingStoreBase.requestHelper'))
      .value;
  Computed<String?>? _$defaultCurrencyComputed;

  @override
  String? get defaultCurrency => (_$defaultCurrencyComputed ??=
          Computed<String?>(() => super.defaultCurrency,
              name: 'SettingStoreBase.defaultCurrency'))
      .value;
  Computed<String?>? _$currencyComputed;

  @override
  String? get currency =>
      (_$currencyComputed ??= Computed<String?>(() => super.currency,
              name: 'SettingStoreBase.currency'))
          .value;
  Computed<bool>? _$isCurrencyChangedComputed;

  @override
  bool get isCurrencyChanged => (_$isCurrencyChangedComputed ??= Computed<bool>(
          () => super.isCurrencyChanged,
          name: 'SettingStoreBase.isCurrencyChanged'))
      .value;
  Computed<ObservableMap<String, dynamic>>? _$currenciesComputed;

  @override
  ObservableMap<String, dynamic> get currencies => (_$currenciesComputed ??=
          Computed<ObservableMap<String, dynamic>>(() => super.currencies,
              name: 'SettingStoreBase.currencies'))
      .value;
  Computed<String?>? _$checkoutUrlComputed;

  @override
  String? get checkoutUrl =>
      (_$checkoutUrlComputed ??= Computed<String?>(() => super.checkoutUrl,
              name: 'SettingStoreBase.checkoutUrl'))
          .value;
  Computed<DataScreen?>? _$dataComputed;

  @override
  DataScreen? get data =>
      (_$dataComputed ??= Computed<DataScreen?>(() => super.data,
              name: 'SettingStoreBase.data'))
          .value;
  Computed<bool>? _$enableGetStartComputed;

  @override
  bool get enableGetStart =>
      (_$enableGetStartComputed ??= Computed<bool>(() => super.enableGetStart,
              name: 'SettingStoreBase.enableGetStart'))
          .value;
  Computed<bool>? _$enableSelectLanguageComputed;

  @override
  bool get enableSelectLanguage => (_$enableSelectLanguageComputed ??=
          Computed<bool>(() => super.enableSelectLanguage,
              name: 'SettingStoreBase.enableSelectLanguage'))
      .value;
  Computed<bool>? _$enableAllowLocationComputed;

  @override
  bool get enableAllowLocation => (_$enableAllowLocationComputed ??=
          Computed<bool>(() => super.enableAllowLocation,
              name: 'SettingStoreBase.enableAllowLocation'))
      .value;
  Computed<bool>? _$enableUsingBiometricComputed;

  @override
  bool get enableUsingBiometric => (_$enableUsingBiometricComputed ??=
          Computed<bool>(() => super.enableUsingBiometric,
              name: 'SettingStoreBase.enableUsingBiometric'))
      .value;

  late final _$_supportedLanguagesAtom =
      Atom(name: 'SettingStoreBase._supportedLanguages', context: context);

  @override
  ObservableList<Language> get _supportedLanguages {
    _$_supportedLanguagesAtom.reportRead();
    return super._supportedLanguages;
  }

  @override
  set _supportedLanguages(ObservableList<Language> value) {
    _$_supportedLanguagesAtom.reportWrite(value, super._supportedLanguages, () {
      super._supportedLanguages = value;
    });
  }

  late final _$_langAtom =
      Atom(name: 'SettingStoreBase._lang', context: context);

  @override
  String get _lang {
    _$_langAtom.reportRead();
    return super._lang;
  }

  @override
  set _lang(String value) {
    _$_langAtom.reportWrite(value, super._lang, () {
      super._lang = value;
    });
  }

  late final _$_localeAtom =
      Atom(name: 'SettingStoreBase._locale', context: context);

  @override
  String get _locale {
    _$_localeAtom.reportRead();
    return super._locale;
  }

  @override
  set _locale(String value) {
    _$_localeAtom.reportWrite(value, super._locale, () {
      super._locale = value;
    });
  }

  late final _$_darkModeAtom =
      Atom(name: 'SettingStoreBase._darkMode', context: context);

  @override
  bool get _darkMode {
    _$_darkModeAtom.reportRead();
    return super._darkMode;
  }

  @override
  set _darkMode(bool value) {
    _$_darkModeAtom.reportWrite(value, super._darkMode, () {
      super._darkMode = value;
    });
  }

  late final _$_loadingAtom =
      Atom(name: 'SettingStoreBase._loading', context: context);

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$tabsAtom = Atom(name: 'SettingStoreBase.tabs', context: context);

  @override
  ObservableList<String?> get tabs {
    _$tabsAtom.reportRead();
    return super.tabs;
  }

  @override
  set tabs(ObservableList<String?> value) {
    _$tabsAtom.reportWrite(value, super.tabs, () {
      super.tabs = value;
    });
  }

  late final _$_dataAtom =
      Atom(name: 'SettingStoreBase._data', context: context);

  @override
  DataScreen? get _data {
    _$_dataAtom.reportRead();
    return super._data;
  }

  @override
  set _data(DataScreen? value) {
    _$_dataAtom.reportWrite(value, super._data, () {
      super._data = value;
    });
  }

  late final _$_currenciesAtom =
      Atom(name: 'SettingStoreBase._currencies', context: context);

  @override
  ObservableMap<String, dynamic> get _currencies {
    _$_currenciesAtom.reportRead();
    return super._currencies;
  }

  @override
  set _currencies(ObservableMap<String, dynamic> value) {
    _$_currenciesAtom.reportWrite(value, super._currencies, () {
      super._currencies = value;
    });
  }

  late final _$_defaultCurrencyAtom =
      Atom(name: 'SettingStoreBase._defaultCurrency', context: context);

  @override
  String? get _defaultCurrency {
    _$_defaultCurrencyAtom.reportRead();
    return super._defaultCurrency;
  }

  @override
  set _defaultCurrency(String? value) {
    _$_defaultCurrencyAtom.reportWrite(value, super._defaultCurrency, () {
      super._defaultCurrency = value;
    });
  }

  late final _$_currencyAtom =
      Atom(name: 'SettingStoreBase._currency', context: context);

  @override
  String? get _currency {
    _$_currencyAtom.reportRead();
    return super._currency;
  }

  @override
  set _currency(String? value) {
    _$_currencyAtom.reportWrite(value, super._currency, () {
      super._currency = value;
    });
  }

  late final _$_checkoutUrlAtom =
      Atom(name: 'SettingStoreBase._checkoutUrl', context: context);

  @override
  String? get _checkoutUrl {
    _$_checkoutUrlAtom.reportRead();
    return super._checkoutUrl;
  }

  @override
  set _checkoutUrl(String? value) {
    _$_checkoutUrlAtom.reportWrite(value, super._checkoutUrl, () {
      super._checkoutUrl = value;
    });
  }

  late final _$_enableGetStartAtom =
      Atom(name: 'SettingStoreBase._enableGetStart', context: context);

  @override
  bool get _enableGetStart {
    _$_enableGetStartAtom.reportRead();
    return super._enableGetStart;
  }

  @override
  set _enableGetStart(bool value) {
    _$_enableGetStartAtom.reportWrite(value, super._enableGetStart, () {
      super._enableGetStart = value;
    });
  }

  late final _$_enableSelectLanguageAtom =
      Atom(name: 'SettingStoreBase._enableSelectLanguage', context: context);

  @override
  bool get _enableSelectLanguage {
    _$_enableSelectLanguageAtom.reportRead();
    return super._enableSelectLanguage;
  }

  @override
  set _enableSelectLanguage(bool value) {
    _$_enableSelectLanguageAtom.reportWrite(value, super._enableSelectLanguage,
        () {
      super._enableSelectLanguage = value;
    });
  }

  late final _$_enableAllowLocationAtom =
      Atom(name: 'SettingStoreBase._enableAllowLocation', context: context);

  @override
  bool get _enableAllowLocation {
    _$_enableAllowLocationAtom.reportRead();
    return super._enableAllowLocation;
  }

  @override
  set _enableAllowLocation(bool value) {
    _$_enableAllowLocationAtom.reportWrite(value, super._enableAllowLocation,
        () {
      super._enableAllowLocation = value;
    });
  }

  late final _$_enableUsingBiometricAtom =
      Atom(name: 'SettingStoreBase._enableUsingBiometric', context: context);

  @override
  bool get _enableUsingBiometric {
    _$_enableUsingBiometricAtom.reportRead();
    return super._enableUsingBiometric;
  }

  @override
  set _enableUsingBiometric(bool value) {
    _$_enableUsingBiometricAtom.reportWrite(value, super._enableUsingBiometric,
        () {
      super._enableUsingBiometric = value;
    });
  }

  late final _$changeLanguageAsyncAction =
      AsyncAction('SettingStoreBase.changeLanguage', context: context);

  @override
  Future<void> changeLanguage(String value) {
    return _$changeLanguageAsyncAction.run(() => super.changeLanguage(value));
  }

  late final _$changeCurrencyAsyncAction =
      AsyncAction('SettingStoreBase.changeCurrency', context: context);

  @override
  Future<void> changeCurrency(String value) {
    return _$changeCurrencyAsyncAction.run(() => super.changeCurrency(value));
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('SettingStoreBase.setDarkMode', context: context);

  @override
  Future<void> setDarkMode({required bool value}) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(value: value));
  }

  late final _$closeGetStartAsyncAction =
      AsyncAction('SettingStoreBase.closeGetStart', context: context);

  @override
  Future<void> closeGetStart() {
    return _$closeGetStartAsyncAction.run(() => super.closeGetStart());
  }

  late final _$closeSelectLanguageAsyncAction =
      AsyncAction('SettingStoreBase.closeSelectLanguage', context: context);

  @override
  Future<void> closeSelectLanguage() {
    return _$closeSelectLanguageAsyncAction
        .run(() => super.closeSelectLanguage());
  }

  late final _$closeAllowLocationAsyncAction =
      AsyncAction('SettingStoreBase.closeAllowLocation', context: context);

  @override
  Future<void> closeAllowLocation() {
    return _$closeAllowLocationAsyncAction
        .run(() => super.closeAllowLocation());
  }

  late final _$setBiometricAsyncAction =
      AsyncAction('SettingStoreBase.setBiometric', context: context);

  @override
  Future<void> setBiometric({required bool value}) {
    return _$setBiometricAsyncAction
        .run(() => super.setBiometric(value: value));
  }

  late final _$getBiometricAsyncAction =
      AsyncAction('SettingStoreBase.getBiometric', context: context);

  @override
  Future getBiometric() {
    return _$getBiometricAsyncAction.run(() => super.getBiometric());
  }

  late final _$getSettingAsyncAction =
      AsyncAction('SettingStoreBase.getSetting', context: context);

  @override
  Future<void> getSetting() {
    return _$getSettingAsyncAction.run(() => super.getSetting());
  }

  late final _$SettingStoreBaseActionController =
      ActionController(name: 'SettingStoreBase', context: context);

  @override
  void setTab(String? tab) {
    final _$actionInfo = _$SettingStoreBaseActionController.startAction(
        name: 'SettingStoreBase.setTab');
    try {
      return super.setTab(tab);
    } finally {
      _$SettingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeTab() {
    final _$actionInfo = _$SettingStoreBaseActionController.startAction(
        name: 'SettingStoreBase.removeTab');
    try {
      return super.removeTab();
    } finally {
      _$SettingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSetting(dynamic json) {
    final _$actionInfo = _$SettingStoreBaseActionController.startAction(
        name: 'SettingStoreBase.setSetting');
    try {
      return super.setSetting(json);
    } finally {
      _$SettingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tabs: ${tabs},
darkMode: ${darkMode},
themeModeKey: ${themeModeKey},
languageKey: ${languageKey},
imageKey: ${imageKey},
locale: ${locale},
supportedLanguages: ${supportedLanguages},
loading: ${loading},
persistHelper: ${persistHelper},
requestHelper: ${requestHelper},
defaultCurrency: ${defaultCurrency},
currency: ${currency},
isCurrencyChanged: ${isCurrencyChanged},
currencies: ${currencies},
checkoutUrl: ${checkoutUrl},
data: ${data},
enableGetStart: ${enableGetStart},
enableSelectLanguage: ${enableSelectLanguage},
enableAllowLocation: ${enableAllowLocation},
enableUsingBiometric: ${enableUsingBiometric}
    ''';
  }
}
