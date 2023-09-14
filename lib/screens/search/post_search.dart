import 'package:cirilla/screens/search/widget/post/result_post.dart';
import 'package:cirilla/screens/search/widget/post/search_post.dart';
import 'package:cirilla/types/types.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

class PostSearchDelegate extends SearchDelegate<String?> {
  PostSearchDelegate(BuildContext context, TranslateType translate)
      : super(searchFieldLabel: translate('post_category_search'));

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
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(FeatherIcons.arrowLeft, size: 22),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty || query == "") Container();
    return SearchPost(
      search: query,
      onChange: (String? title) {
        query = title ?? '';
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ResultPost(
      search: query,
      clearText: () {
        query = '';
        showSuggestions(context);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isEmpty)
        IconButton(
          tooltip: 'Close',
          icon: const Icon(FeatherIcons.x, size: 22),
          onPressed: () => Navigator.pop(context),
        )
      else
        IconButton(
          tooltip: 'Clear',
          icon: const Icon(FeatherIcons.x, size: 22),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }
}
