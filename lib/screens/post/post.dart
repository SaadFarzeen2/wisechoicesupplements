import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/post/post_event.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'post_html.dart';
import 'post_audio.dart';

class PostScreen extends StatefulWidget {
  static const routeName = '/post';

  final dynamic args;
  final SettingStore store;

  const PostScreen({Key? key, this.args, required this.store}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with PostMixin, AppBarMixin, SnackMixin, LoadingMixin {
  bool _loading = true;
  Post? _post;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Post? post = widget.args?['post'];
    // Instance post receive
    if (post is Post) {
      _post = post;
      setState(() {
        _loading = false;
      });
    } else {
      getPost(ConvertData.stringToInt(widget.args?['id']));
    }
  }

  Future<void> getPost(int id) async {
    try {
      _post = await Provider.of<RequestHelper>(context).getPost(id: id);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _post = null;
      });
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading || _post == null ? Center(child: buildLoading(context, isLoading: _loading)) : buildLayout(_post),
    );
  }

  Widget buildLayout(Post? post) {
    return Observer(builder: (_) {
      Data? data = widget.store.data!.screens!['postDetail'];

      // Configs
      WidgetConfig? widgetConfig = data != null ? data.widgets!['postDetailPage'] : null;

      Map<String, dynamic>? configs = data?.configs;

      // Layout
      String? layout = configs != null ? widgetConfig!.layout : Strings.postDetailLayoutDefault;
      List<dynamic>? rows = widgetConfig != null ? widgetConfig.fields!['rows'] : null;
      bool enableBlock = widgetConfig?.fields?['enableBlock'] ?? true;

      if (post!.type == 'tribe_events') {
        return PostEvent(post: post);
      }

      if (post.format == 'audio') {
        return PostAudio(post: post, configs: configs);
      }

      Widget blocks = PostHtml(
        post: post,
        layout: layout,
        styles: widgetConfig!.styles,
        configs: configs,
        rows: rows,
        enableBlock: enableBlock,
      );

      return blocks;
    });
  }
}
