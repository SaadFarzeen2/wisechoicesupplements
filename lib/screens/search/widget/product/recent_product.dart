import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/search/search_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cirilla/mixins/unescape_mixin.dart';

class RecentSearch extends StatefulWidget {
  final String? search;
  final List<PostSearch>? data;
  final SearchStore? searchStore;
  final ValueChanged<String>? onChange;
  const RecentSearch({
    Key? key,
    this.search,
    this.data,
    this.searchStore,
    this.onChange,
  }) : super(key: key);
  @override
  State<RecentSearch> createState() => _RecentSearchState();
}

class _RecentSearchState extends State<RecentSearch> {
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (_) {
        if (widget.searchStore!.data.isEmpty) {
          return Container();
        }
        List<dynamic> dataRecent = widget.searchStore!.data.map((String title) => {'title': title}).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsetsDirectional.only(start: 16, top: 24, end: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(translate('search_recent'), style: Theme.of(context).textTheme.titleLarge),
                    InkWell(
                      onTap: () {
                        widget.searchStore!.removeAllSearch();
                      },
                      child: Text(translate('search_clear_all'), style: Theme.of(context).textTheme.bodyMedium),
                    )
                  ],
                )),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  String title = unescape(dataRecent.elementAt(index)['title']);
                  return ListTile(
                    onTap: () {
                      widget.onChange!(title);
                    },
                    title: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                    ),
                    trailing: InkWell(
                      onTap: () {
                        widget.searchStore!.removeSearch(dataRecent.elementAt(index)['title']);
                      },
                      child: const Icon(FeatherIcons.x, size: 16),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: dataRecent.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
