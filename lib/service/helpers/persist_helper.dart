import 'package:cirilla/constants/app.dart';
import 'package:cirilla/service/constants/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistHelper {
  final SharedPreferences sharedPreferences;

  PersistHelper(this.sharedPreferences);

  /// Save setting dark mode
  Future<bool> saveDarkMode(bool value) async {
    return await sharedPreferences.setBool(Preferences.darkMode, value);
  }

  /// Get setting dark mode
  Future<bool> getDarkMode() async {
    return sharedPreferences.getBool(Preferences.darkMode) ?? false;
  }

  /// Save user login token
  Future<bool> saveToken(String value) async {
    return await sharedPreferences.setString(Preferences.authToken, value);
  }

  /// Get user login token
  String? getToken() {
    return sharedPreferences.getString(Preferences.authToken);
  }

  /// Remove user login token
  Future<bool> removeToken() async {
    return sharedPreferences.remove(Preferences.authToken);
  }

  /// Get cart key
  String? getCartKey() {
    return sharedPreferences.getString(Preferences.cartKey);
  }

  /// Get guest cart key
  String? getGuestCartKey() {
    return sharedPreferences.getString(Preferences.guestCartKey);
  }

  /// Save cart key
  Future<bool> saveCartKey(String value) async {
    return await sharedPreferences.setString(Preferences.cartKey, value);
  }

  /// Save guest cart key
  Future<bool> saveGuestCartKey(String guestCartKey) async {
    return await sharedPreferences.setString(Preferences.guestCartKey, guestCartKey);
  }

  /// Save language
  Future<bool> saveLanguage(String value) async {
    return await sharedPreferences.setString(Preferences.languageKey, value);
  }

  /// Get language
  Future<String> getLanguage() async {
    return sharedPreferences.getString(Preferences.languageKey) ?? defaultLanguage;
  }

  /// Save currency
  Future<bool> saveCurrency(String value) async {
    return await sharedPreferences.setString(Preferences.currencyKey, value);
  }

  /// Get currency
  Future<String?> getCurrency() async {
    return sharedPreferences.getString(Preferences.currencyKey);
  }

  /// Save WishList
  Future<bool> saveWishList(List<String> value) async {
    return await sharedPreferences.setStringList(Preferences.wishlistKey, value);
  }

  /// Get WishList
  List<String>? getWishList() {
    return sharedPreferences.getStringList(Preferences.wishlistKey);
  }

  /// Remove wishlist
  Future<bool> removeWishlist() async {
    return await sharedPreferences.remove(Preferences.wishlistKey);
  }

  /// Save product recently
  Future<bool> saveProductRecently(List<String> value) async {
    return await sharedPreferences.setStringList(Preferences.productRecentlyKey, value);
  }

  /// Get product recently
  Future<List<String>?> getProductRecently() async {
    return sharedPreferences.getStringList(Preferences.productRecentlyKey);
  }

  /// Save post WishList
  Future<bool> savePostWishList(List<String> value) async {
    return await sharedPreferences.setStringList(Preferences.postWishlistKey, value);
  }

  /// Get post WishList
  Future<List<String>?> getPostWishList() async {
    return sharedPreferences.getStringList(Preferences.postWishlistKey);
  }

  /// Save Search
  Future<bool> saveSearch(List<String> value) async {
    return await sharedPreferences.setStringList(Preferences.searchKey, value);
  }

  /// Get Search
  Future<List<String>?> getSearch() async {
    return sharedPreferences.getStringList(Preferences.searchKey);
  }

  /// Save Search
  Future<bool> saveSearchPost(List<String> value) async {
    return await sharedPreferences.setStringList(Preferences.searchPostKey, value);
  }

  /// Get Search
  Future<List<String>?> getSearchPost() async {
    return sharedPreferences.getStringList(Preferences.searchPostKey);
  }

  /// Save enableGetStartKey
  Future<bool> saveEnableGetStart(bool value) async {
    return await sharedPreferences.setBool(Preferences.enableGetStartKey, value);
  }

  /// Get enableGetStartKey
  Future<bool> getEnableGetStart() async {
    return sharedPreferences.getBool(Preferences.enableGetStartKey) ?? true;
  }

  /// Save enableSelectLanguageKey
  Future<bool> saveEnableSelectLanguage(bool value) async {
    return await sharedPreferences.setBool(Preferences.enableSelectLanguageKey, value);
  }

  /// Get enableSelectLanguageKey
  Future<bool> getEnableSelectLanguage() async {
    return sharedPreferences.getBool(Preferences.enableSelectLanguageKey) ?? true;
  }

  /// Save enableAllowLocationKey
  Future<bool> saveEnableAllowLocation(bool value) async {
    return await sharedPreferences.setBool(Preferences.enableAllowLocation, value);
  }

  /// Get enableAllowLocationKey
  Future<bool> getEnableAllowLocation() async {
    return sharedPreferences.getBool(Preferences.enableAllowLocation) ?? true;
  }

  /// Save messages
  Future<bool> saveMessages(List<String> value) async {
    return await sharedPreferences.setStringList(Preferences.messagesKey, value);
  }

  /// Get messages
  Future<List<String>?> getMessages() async {
    return sharedPreferences.getStringList(Preferences.messagesKey);
  }

  /// Delete messages
  Future<bool> removeMessages() async {
    return sharedPreferences.remove(Preferences.messagesKey);
  }

  /// Save location
  Future<bool> saveLocation(String value) async {
    return await sharedPreferences.setString(Preferences.locationKey, value);
  }

  /// Get location
  Future<String?> getLocation() async {
    return sharedPreferences.getString(Preferences.locationKey);
  }

  /// Save locations
  Future<bool> saveLocations(List<String> value) async {
    return await sharedPreferences.setStringList(Preferences.savedKey, value);
  }

  /// Get locations
  Future<List<String>?> getLocations() async {
    return sharedPreferences.getStringList(Preferences.savedKey);
  }

  /// Save settings
  Future<bool> saveSettings(String value) async {
    return await sharedPreferences.setString(Preferences.settings, value);
  }

  /// Get settings
  String? getSettings() {
    return sharedPreferences.getString(Preferences.settings);
  }

  /// Remove settings
  Future<bool> removeSettings() async {
    return await sharedPreferences.remove(Preferences.settings);
  }

  /// Save categories
  Future<bool> saveCategories(String value) async {
    return await sharedPreferences.setString(Preferences.categories, value);
  }

  /// Get categories
  String? getCategories() {
    return sharedPreferences.getString(Preferences.categories);
  }

  /// Remove categories
  Future<bool> removeCategories() async {
    return await sharedPreferences.remove(Preferences.categories);
  }

  /// Set watched videos
  Future<bool> setWatchedVideo(List<String> watchedVideo) async {
    return await sharedPreferences.setStringList(Preferences.watchedVideo, watchedVideo);
  }

  /// Get watched videos
  List<String> getWatchedVideo() {
    return sharedPreferences.getStringList(Preferences.watchedVideo) ?? [];
  }

  /// Save usingBiometric
  Future<bool> saveUsingBiometric(bool value) async {
    return await sharedPreferences.setBool(Preferences.usingBiometric, value);
  }

  /// Get usingBiometric
  bool getUsingBiometric() {
    return sharedPreferences.getBool(Preferences.usingBiometric) ?? false;
  }

  /// Remove usingBiometric
  Future<bool> removeUsingBiometric() async {
    return await sharedPreferences.remove(Preferences.usingBiometric);
  }

  /// Save Token Biometric
  Future<bool> saveTokenBiometric(String value) async {
    return await sharedPreferences.setString(Preferences.tokenBiometric, value);
  }

  /// Get Token Biometric
  String? getTokenBiometric() {
    return sharedPreferences.getString(Preferences.tokenBiometric);
  }

  /// Remove Token Biometric
  Future<bool> removeTokenBiometric() async {
    return await sharedPreferences.remove(Preferences.tokenBiometric);
  }

  /// Save share_key of wishlist plugin
  Future<bool> saveShareKeyWishlist(String value) async {
    return await sharedPreferences.setString(Preferences.shareKeyWishlist, value);
  }

  /// Get share_key of wishlist plugin
  String? getShareKeyWishlist() {
    return sharedPreferences.getString(Preferences.shareKeyWishlist);
  }

  /// Remove share_key of wishlist plugin
  Future<bool> removeShareKeyWishlist() async {
    return await sharedPreferences.remove(Preferences.shareKeyWishlist);
  }
}
