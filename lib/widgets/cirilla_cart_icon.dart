import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'cirilla_badge.dart';

const defaultIcon = Icon(
  FeatherIcons.shoppingCart,
  size: 22.0,
);

class CirillaCartIcon extends StatelessWidget with NavigationMixin {
  final Color? color;
  final Widget? icon;
  final bool? enableCount;
  final Widget? cartImage;

  const CirillaCartIcon({
    Key? key,
    this.color,
    this.icon,
    this.enableCount = true,
    this.cartImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartStore cartStore = Provider.of<AuthStore>(context).cartStore;

    return InkResponse(
      onTap: () => navigate(context, {
        'type': 'tab',
        'route': '/',
        'args': {'key': 'screens_cart'}
      }),
      child: Container(
        padding: paddingHorizontalTiny,
        height: 38,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Observer(
          builder: (_) => Row(
            children: [
              if (enableCount!)
                CirillaBadge(
                  size: 18,
                  padding: paddingHorizontalTiny,
                  label: "${cartStore.count}",
                  type: CirillaBadgeType.error,
                ),
              cartImage ?? icon ?? defaultIcon,
            ],
          ),
        ),
      ),
    );
  }
}
