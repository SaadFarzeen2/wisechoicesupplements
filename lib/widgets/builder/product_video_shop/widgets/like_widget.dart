import 'dart:async';

import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import '../product_video_shop.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../store/app_store.dart';

class LikeWidgetVideoShop extends StatefulWidget {
  const LikeWidgetVideoShop({
    Key? key,
    required this.liked,
    required this.likes,
    required this.updateData,
    required this.id,
    required this.appStore,
    required this.userId,
  }) : super(key: key);
  final bool liked;
  final int likes;
  final int? id;
  final Function(int likes, bool liked) updateData;
  final AppStore appStore;
  final String userId;
  @override
  State<LikeWidgetVideoShop> createState() => _LikeWidgetVideoShopState();
}

class _LikeWidgetVideoShopState extends State<LikeWidgetVideoShop>{
  late bool _localLiked;
  late int _localLikes;
  late RequestHelper _requestHelper;
  LikeStore? _likeStore;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initLikeState();
  }

  @override
  void didChangeDependencies() {
    _requestHelper = Provider.of<SettingStore>(context).requestHelper;
    super.didChangeDependencies();
  }

  _initLikeState(){
    _likeStore = widget.appStore.getStoreByKey(widget.id.toString());
    if(_likeStore != null){
      //user logged
      if(widget.userId.isNotEmpty){
        if(_likeStore!.userId == widget.userId){
          _localLiked = _likeStore!.liked;
        }else{
          _localLiked = widget.liked;
        }
        //user not login
      }else{
        _localLiked = _likeStore!.liked;
      }
      _localLikes = _likeStore!.likes;
    }else{
      _localLiked = (widget.userId.isNotEmpty) ? widget.liked : false ;
      _localLikes = widget.likes;
    }
  }

  void _updateLikeStore({required int likes,required bool liked}){
    widget.appStore.removeStoreByKey(widget.id.toString());
    widget.appStore.addStore(
      LikeStore(
        key: widget.id.toString(),
        likes: likes,
        liked: liked,
        userId: widget.userId,
      ),
    );
  }

  Future<void> _likeVideo() async{
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      Map<String, dynamic> queryParameters = {
        'app-builder-decode': 'true',
      };
      Map<String, dynamic> body = {'post_id': widget.id.toString()};

      if (_localLiked) {
        if(widget.userId.isEmpty){
          body.addAll({'type': 'negative'});
        }
        _requestHelper.likeProductVideo(queryParameters: queryParameters, body: body);
        // Update data to like store
        _updateLikeStore(likes: _localLikes - 1, liked: false);
        setState(() {
          _localLikes -= 1;
          _localLiked = false;
          widget.updateData(_localLikes, _localLiked);
        });
      } else {
        if(widget.userId.isEmpty){
          body.addAll({'type': 'positive'});
        }
        _requestHelper.likeProductVideo(queryParameters: queryParameters, body: body);
        // Update data to like store
        _updateLikeStore(likes: _localLikes + 1, liked: true);
        setState(() {
          _localLikes += 1;
          _localLiked = true;
          widget.updateData(_localLikes, _localLiked);
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      width: 60.0,
      height: 60.0,
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              await _likeVideo();
            },
            child: Icon(Icons.favorite, size: 30.0, color: (_localLiked) ? Colors.red : Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              NumberFormat.compact().format(_localLikes),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
