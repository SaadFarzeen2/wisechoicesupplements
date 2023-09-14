import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';

class PostTagWidget extends StatelessWidget {
  final Post? post;
  final double? paddingHorizontal;

  const PostTagWidget({Key? key, this.post, this.paddingHorizontal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 0),
          child: Text(translate('comment_tags'), style: theme.textTheme.titleSmall),
        ),
        if (post!.postTags!.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 0),
              itemBuilder: (BuildContext context, int index) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.textTheme.titleSmall?.color,
                  backgroundColor: theme.colorScheme.surface,
                  textStyle: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                  elevation: 0,
                  minimumSize: const Size(0, 0),
                  padding: paddingHorizontalLarge,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, PostListScreen.routeName, arguments: {'tag': post!.postTags![index]});
                },
                child: Text(post!.postTags![index].name!),
              ),
              separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 8),
              itemCount: post!.postTags!.length,
            ),
          ),
        ],
      ],
    );
  }
}
