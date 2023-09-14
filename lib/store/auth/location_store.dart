import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:mobx/mobx.dart';
import 'dart:convert';

part 'location_store.g.dart';

class LocationStore = LocationStoreBase with _$LocationStore;

abstract class LocationStoreBase with Store {
  // Request helper instance
  late PersistHelper _persistHelper;

  // constructor:-------------------------------------------------------------------------------------------------------
  LocationStoreBase(PersistHelper persistHelper) {
    _persistHelper = persistHelper;
    init();
  }

  /// Restore persist location data
  Future init() async {
    // Get location
    String? location = await _persistHelper.getLocation();

    // Restore the location
    if (location != null && location != '') {
      _location = UserLocation.fromJson(json.decode(location));
    }

    // Get list locations
    List<String> locations = await _persistHelper.getLocations() ?? [];

    // Restore list location
    _locations = ObservableList<UserLocation>.of(
      locations.map((String v) => UserLocation.fromJson(json.decode(v))).toList(),
    );
  }

  // store variables:-----------------------------------------------------------

  /// User current location variable
  @observable
  UserLocation _location = UserLocation();

  /// List saved location variable
  @observable
  ObservableList<UserLocation> _locations = ObservableList<UserLocation>.of([]);

  @computed
  UserLocation get location => _location;

  @computed
  ObservableList<UserLocation> get locations => _locations;

  // actions:-------------------------------------------------------------------

  /// Set current location for app
  ///
  /// @param UserLocation location The location object
  @action
  Future<void> setLocation({required UserLocation location}) async {
    await _persistHelper.saveLocation(location.toString());
    _location = location;
  }

  /// Save location to list
  ///
  /// @param UserLocation location The location object
  ///
  @action
  Future<void> saveLocation({required UserLocation location}) async {
    // Get list locations
    List<String> locations = await _persistHelper.getLocations() ?? [];

    // Add to list
    locations.add(location.toString());

    // Save list
    await _persistHelper.saveLocations(locations);

    // Update data
    _locations = ObservableList<UserLocation>.of(
      locations.map((String v) => UserLocation.fromJson(json.decode(v))).toList(),
    );
  }

  /// Delete location from list
  ///
  /// @param String id The id of User location object
  @action
  Future<void> deleteLocation({required String id}) async {
    // Get list locations
    List<String> locations = await _persistHelper.getLocations() ?? [];

    // Filter Location
    List<UserLocation> filterLocations = locations
        .map((String v) => UserLocation.fromJson(json.decode(v)))
        .where((UserLocation userLocation) => userLocation.id != id)
        .toList();

    // Save list
    await _persistHelper.saveLocations(filterLocations.map((UserLocation u) => u.toString()).toList());

    // Update data
    _locations = ObservableList<UserLocation>.of(filterLocations);
  }

  /// Edit location from list
  ///
  /// @param UserLocation location The location object
  @action
  Future<void> editLocation({required UserLocation location}) async {
    // Get list locations
    List<String> locations = await _persistHelper.getLocations() ?? [];

    // Update Location
    List<UserLocation> filterLocations = locations
        .map((String v) => UserLocation.fromJson(json.decode(v)))
        .map((UserLocation userLocation) => userLocation.id == location.id ? location : userLocation)
        .toList();

    // Save list
    await _persistHelper.saveLocations(filterLocations.map((UserLocation u) => u.toString()).toList());

    // Update data
    _locations = ObservableList<UserLocation>.of(filterLocations);
  }
}
