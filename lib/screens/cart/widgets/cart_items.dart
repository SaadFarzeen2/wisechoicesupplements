import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/screens/product/product.dart';
import 'package:cirilla/widgets/cirilla_quantity.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:ui/ui.dart';
import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'dart:async';

class Item extends StatefulWidget {
  final CartItem cartItem;

  final Function? onRemove;

  final Function(CartItem cartItem, int value) updateQuantity;

  bool iscartpage;

  Item(
      {Key? key,
      required this.cartItem,
      this.onRemove,
      this.iscartpage = false,
      required this.updateQuantity})
      : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item>
    with Utility, CartMixin, SnackMixin, ShapeMixin {
  int _qty = 0;

  Timer? timer;
  int milliseconds = 250;
  int? index;

  Future<void> onChanged(int value) async {
    setState(() {
      _qty = value;
    });
    if (timer != null) {
      timer?.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), () {
      if (mounted) {
        widget.updateQuantity(widget.cartItem, value);
      }
    });
  }

  @override
  void initState() {
    _qty = get(widget.cartItem.quantity, [], 1);
    super.initState();
  }

  void _navigate() {
    int? id = widget.cartItem.id;
    if (widget.cartItem.variation != null &&
        widget.cartItem.variation!.isNotEmpty) {
      Navigator.of(context).pushNamed('${ProductScreen.routeName}/$id',
          arguments: {'type': 'variable'});
    } else {
      Navigator.of(context).pushNamed('${ProductScreen.routeName}/$id');
    }
  }

  void buildModalEmpty(BuildContext context, ThemeData theme, String name) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    Future<void> future = showModalBottomSheet<String>(
      context: context,
      shape: borderRadiusTop(),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: paddingHorizontal.copyWith(
              top: itemPaddingMedium, bottom: itemPaddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                translate('product_remove_title', {'name': name}),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, 'remove'),
                        child: Text(translate('product_remove_ok')),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: theme.textTheme.titleMedium?.color,
                          backgroundColor: theme.colorScheme.surface,
                        ),
                        child: Text(translate('product_remove_cancel')),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    future.then((dynamic value) {
      if (value == 'remove') {
        widget.onRemove!();
      } else {
        onChanged(_qty);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name = get(widget.cartItem.name, [], '');

    String? currencyCode = get(widget.cartItem.prices, ['currency_code'], null);

    int? unit = get(widget.cartItem.prices, ['currency_minor_unit'], 0);

    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    HtmlUnescape unescape = HtmlUnescape();

    return ProductCartItem(
      padding: paddingHorizontal.add(paddingVerticalLarge),
      image: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: _navigate,
          child: _buildImage(),
        ),
      ),
      name: InkWell(
        onTap: _navigate,
        child: Text(
          unescape.convert(name),
          style: textTheme.titleSmall,
        ),
      ),
      attribute: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.cartItem.itemData != null)
            ...List.generate(
              widget.cartItem.itemData!.length,
              (index) {
                Map itemData = widget.cartItem.itemData!.elementAt(index);
                String? name = get(itemData, ['name'], '');
                String? value = get(itemData, ['value'], '');
                return RichText(
                  text: TextSpan(
                    text: '${unescape.convert(name!)}: ',
                    style: textTheme.bodySmall,
                    children: <TextSpan>[
                      TextSpan(
                          text: value,
                          style: textTheme.bodySmall
                              ?.copyWith(color: textTheme.titleMedium?.color)),
                    ],
                  ),
                );
              },
            ),
          ...List.generate(
            widget.cartItem.variation!.length,
            (index) {
              Map variation = widget.cartItem.variation!.elementAt(index);
              String? attribute = get(variation, ['attribute'], '');
              String? value = get(variation, ['value'], '');
              return RichText(
                text: TextSpan(
                  text: '$attribute: ',
                  style: textTheme.bodySmall,
                  children: <TextSpan>[
                    TextSpan(
                        text: value,
                        style: textTheme.bodySmall
                            ?.copyWith(color: textTheme.titleMedium?.color)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      price: Text(
          convertCurrency(context,
              currency: currencyCode,
              price: widget.cartItem.prices!['price'],
              unit: unit)!,
          style: textTheme.titleSmall),
      quantity: CirillaQuantity(
        iscartpage: widget.iscartpage,
        value: _qty,
        color: theme.colorScheme.surface,
        textStyle:
            textTheme.bodyMedium?.copyWith(color: textTheme.titleMedium?.color),
        onChanged: onChanged,
        actionZero: () => buildModalEmpty(context, theme, name),
        min: widget.cartItem.quantityLimit?.minimum ?? 0,
        max: widget.cartItem.quantityLimit?.maximum,
      ),
      onRemove: widget.onRemove as void Function()?,
      remove: Icon(FeatherIcons.trash2,
          size: 14, color: textTheme.bodyLarge?.color),
    );
  }

  Widget _buildImage() {
    return ImageLoading(
      widget.cartItem.images!.isEmpty
          ? Assets.noImageUrl
          : widget.cartItem.images!.elementAt(0)['thumbnail'] ??
              Assets.noImageUrl,
      width: 86,
      height: 102,
      fit: BoxFit.cover,
    );
  }
}
