// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LocationStore on LocationStoreBase, Store {
  Computed<UserLocation>? _$locationComputed;

  @override
  UserLocation get location =>
      (_$locationComputed ??= Computed<UserLocation>(() => super.location, name: '_LocationStore.location')).value;
  Computed<ObservableList<UserLocation>>? _$locationsComputed;

  @override
  ObservableList<UserLocation> get locations => (_$locationsComputed ??=
          Computed<ObservableList<UserLocation>>(() => super.locations, name: '_LocationStore.locations'))
      .value;

  final _$_locationAtom = Atom(name: '_LocationStore._location');

  @override
  UserLocation get _location {
    _$_locationAtom.reportRead();
    return super._location;
  }

  @override
  set _location(UserLocation value) {
    _$_locationAtom.reportWrite(value, super._location, () {
      super._location = value;
    });
  }

  final _$_locationsAtom = Atom(name: '_LocationStore._locations');

  @override
  ObservableList<UserLocation> get _locations {
    _$_locationsAtom.reportRead();
    return super._locations;
  }

  @override
  set _locations(ObservableList<UserLocation> value) {
    _$_locationsAtom.reportWrite(value, super._locations, () {
      super._locations = value;
    });
  }

  final _$setLocationAsyncAction = AsyncAction('_LocationStore.setLocation');

  @override
  Future<void> setLocation({required UserLocation location}) {
    return _$setLocationAsyncAction.run(() => super.setLocation(location: location));
  }

  final _$saveLocationAsyncAction = AsyncAction('_LocationStore.saveLocation');

  @override
  Future<void> saveLocation({required UserLocation location}) {
    return _$saveLocationAsyncAction.run(() => super.saveLocation(location: location));
  }

  final _$deleteLocationAsyncAction = AsyncAction('_LocationStore.deleteLocation');

  @override
  Future<void> deleteLocation({required String id}) {
    return _$deleteLocationAsyncAction.run(() => super.deleteLocation(id: id));
  }

  final _$editLocationAsyncAction = AsyncAction('_LocationStore.editLocation');

  @override
  Future<void> editLocation({required UserLocation location}) {
    return _$editLocationAsyncAction.run(() => super.editLocation(location: location));
  }

  @override
  String toString() {
    return '''
location: ${location},
locations: ${locations}
    ''';
  }
}
