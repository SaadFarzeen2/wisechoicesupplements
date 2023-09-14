import 'package:cirilla/models/models.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class PostAction extends StatelessWidget {
  final Post? post;
  final Color? color;
  final Axis axis;
  final Map<String, dynamic>? configs;
  final GlobalKey? dataKey;

  const PostAction({
    Key? key,
    this.post,
    this.color,
    this.axis = Axis.horizontal,
    this.configs,
    this.dataKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool enableComment = get(configs, ['enableAppbarComment'], true);
    bool enableWishlist = get(configs, ['enableAppbarWishList'], true);
    bool enableShare = get(configs, ['enableAppbarShare'], true);

    if (axis == Axis.vertical) {
      return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              if (enableComment) ...[
                PostNavigateComment(
                  post: post,
                  color: color,
                  dataKey: dataKey,
                ),
                const SizedBox(height: 32),
              ],
              if (enableWishlist) ...[
                PostWishlist(post: post, color: color),
                const SizedBox(height: 32),
              ],
              if (enableShare) PostShare(post: post, color: color),
            ],
          ));
    }
    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 32,
        children: [
          if (enableComment)
            PostNavigateComment(
              post: post,
              color: color,
              dataKey: dataKey,
            ),
          if (enableWishlist) PostWishlist(post: post, color: color),
          if (enableShare) PostShare(post: post, color: color),
        ],
      ),
    );
  }
}

class PostWishlist extends StatefulWidget {
  final Post? post;
  final Color? color;

  const PostWishlist({
    Key? key,
    this.post,
    this.color,
  }) : super(key: key);

  @override
  State<PostWishlist> createState() => _PostWishlistState();
}

class _PostWishlistState extends State<PostWishlist> with PostWishListMixin {
  ///
  /// Handle wishlist
  void _wishlist(BuildContext context) {
    if (widget.post == null || widget.post!.id == null) return;
    addWishList(postId: widget.post!.id);
  }

  @override
  Widget build(BuildContext context) {
    bool select = existWishList(postId: widget.post!.id);
    return InkWell(
      onTap: () => _wishlist(context),
      child: Icon(!select ? Icons.bookmark_border : Icons.bookmark, size: 20, color: widget.color),
    );
  }
}

class PostNavigateComment extends StatelessWidget {
  final Post? post;
  final Color? color;
  final GlobalKey? dataKey;
  const PostNavigateComment({
    Key? key,
    this.post,
    this.color,
    this.dataKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (dataKey?.currentContext != null) {
          Scrollable.ensureVisible(dataKey!.currentContext!,
              duration: const Duration(
                milliseconds: 600,
              ));
        }
      },
      child: Icon(FeatherIcons.messageCircle, size: 18, color: color),
    );
  }
}

class PostShare extends StatelessWidget {
  final Post? post;
  final Color? color;
  const PostShare({
    Key? key,
    this.post,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Share.share(post!.link!, subject: post!.postTitle),
      child: Icon(FeatherIcons.share2, size: 18, color: color),
    );
  }
}
