import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/screens/search/widget/post/recent_post.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/search/search_post_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/mixins/unescape_mixin.dart';

class SearchPost extends StatefulWidget {
  final String? search;
  final ValueChanged<String>? onChange;

  const SearchPost({
    Key? key,
    this.search,
    this.onChange,
  }) : super(key: key);

  @override
  State<SearchPost> createState() => __SearchPostState();
}

class __SearchPostState extends State<SearchPost> {
  List<PostSearch> _data = [];
  CancelToken? _token;
  SearchPostStore? searchPostStore;

  @override
  void didChangeDependencies() {
    SettingStore settingStore = Provider.of<SettingStore>(context);
    searchPostStore = SearchPostStore(settingStore.persistHelper);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _token?.cancel('cancelled');
    super.dispose();
  }

  Future<void> search(CancelToken? token) async {
    try {
      SettingStore settingStore = Provider.of<SettingStore>(context);
      PostStore postStore = PostStore(Provider.of<RequestHelper>(context));
      List<PostSearch>? data = await postStore.search(queryParameters: {
        'search': widget.search,
        'type': 'post',
        'subtype': 'post',
        'lang': settingStore.locale,
      }, cancelToken: token);
      setState(() {
        _data = List<PostSearch>.of(data!);
      });
    } catch (e) {
      avoidPrint('Cancel fetch');
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (_token != null) {
      _token?.cancel('cancelled');
    }

    setState(() {
      _token = CancelToken();
    });

    search(_token);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.search == '') {
      return RecentSearchPost(
        search: widget.search,
        data: _data,
        searchPostStore: searchPostStore,
        onChange: widget.onChange,
      );
    }
    return ListView.separated(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Navigator.pushNamed(context, '${PostScreen.routeName}/${_data[index].id}');
          searchPostStore!.addSearch(_data[index].title!);
        },
        leading: const Icon(FeatherIcons.search, size: 22),
        horizontalTitleGap: 0,
        title: Text(unescape(_data[index].title!)),
      ),
      itemCount: _data.length,
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
