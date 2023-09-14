import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/widgets/cirilla_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class TabItemCount extends StatelessWidget {
  final String? type;

  const TabItemCount({Key? key, this.type = 'cart'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartStore cartStore = Provider.of<AuthStore>(context).cartStore;
    WishListStore? wishListStore = Provider.of<AuthStore>(context).wishListStore;
    PostWishListStore? postWishListStore = Provider.of<AuthStore>(context).postWishListStore;
    return Observer(
      builder: (_) {
        int cartCount = cartStore.count ?? 0;
        int wishlistCount = wishListStore?.count ?? 0;
        int postWishlistCount = postWishListStore?.count ?? 0;
        return CirillaBadge(
          size: 18,
          padding: paddingHorizontalTiny,
          label: "${type == 'cart' ? cartCount : type == 'wishlist' ? wishlistCount : postWishlistCount}",
          type: CirillaBadgeType.error,
        );
      },
    );
  }
}
