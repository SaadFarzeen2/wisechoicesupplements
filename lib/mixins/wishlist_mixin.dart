import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/wishlist/wishlist_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin WishListMixin<T extends StatefulWidget> on State<T> {
  bool loading = false;

  late WishListStore _wishListStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _wishListStore = Provider.of<AuthStore>(context).wishListStore!;
  }

  Future<void> addWishList({int? productId}) async {
    setState(() {
      loading = true;
    });
    try {
      _wishListStore.addWishList('$productId');
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }

  bool existWishList({int? productId}) {
    List<String> data = _wishListStore.data;
    return data.contains('$productId');
  }
}
