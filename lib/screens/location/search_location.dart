import 'package:cirilla/models/location/prediction.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/types/types.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'search_location/results.dart';
import 'search_location/search.dart';

class SearchLocationScreen extends SearchDelegate<Prediction> {
  final apiClient = GooglePlaceApiHelper();
  List<Prediction> _data = [];
  SearchLocationScreen(
    BuildContext context,
    TranslateType translate, {
    Key? key,
    apiClient,
  }) : super(searchFieldLabel: translate('address_search'));
  setDataSearch(List<Prediction> data) {
    _data = data;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: textTheme.bodyMedium,
        border: InputBorder.none,
      ),
      textTheme: query != '' ? textTheme.copyWith(titleLarge: textTheme.titleSmall) : null,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(FeatherIcons.x, size: 22),
        onPressed: () {
          query = '';
          Navigator.pop(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(FeatherIcons.arrowLeft, size: 22),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Results(
      search: query,
      apiClient: apiClient,
      data: _data,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Search(
      search: query,
      apiClient: apiClient,
      setDataSearch: setDataSearch,
      dataSearch: _data,
    );
  }
}
