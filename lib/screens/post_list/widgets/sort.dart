import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/types/actions.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Sort extends StatelessWidget {
  final Map value;
  final OnChangedBlogType onChanged;

  const Sort({Key? key, required this.value, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    /// List sort data
    const List listSortBy = [
      {
        'key': 'latest',
        'translate_name': 'post_list_sort_latest',
        'query': {
          'order': 'desc',
          'orderby': 'date',
        }
      },
      {
        'key': 'oldest',
        'translate_name': 'post_list_sort_oldest',
        'query': {
          'order': 'asc',
          'orderby': 'date',
        }
      },
    ];

    return Container(
      padding: paddingHorizontal,
      child: Column(
        children: [
          Padding(
            padding: paddingVerticalMedium,
            child: Text(translate('sort_by'), style: theme.textTheme.titleMedium),
          ),
          ...List.generate(
            listSortBy.length,
            (index) {
              Map item = listSortBy[index];
              Color? textColor = item['key'] == value['key'] ? theme.textTheme.titleMedium?.color : null;
              return CirillaTile(
                leading: CirillaRadio(isSelect: item['key'] == value['key']),
                title: Text(translate(item['translate_name']),
                    style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
                isChevron: false,
                onTap: () {
                  onChanged(sort: item);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
