import 'package:cirilla/models/models.dart';
import 'package:flutter/material.dart';
import '../blocks/blocks.dart';
import '../blocks/html_text.dart';

class PostContent extends StatelessWidget {
  final Post? post;

  const PostContent({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (post!.blocks == null) {
      return HtmlText(
        text: post?.content?.rendered ?? '',
        fontColor: theme.textTheme.bodySmall?.color,
      );
    }

    return Column(
      children: List.generate(post!.blocks!.length, (index) {
        if (index == post!.blocks!.length - 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostBlock(block: post!.blocks![index]),
              const SizedBox(height: 50),
              const Divider(
                height: 1,
                thickness: 1,
              ),
            ],
          );
        }
        return PostBlock(block: post!.blocks![index]);
      }),
    );
  }
}
