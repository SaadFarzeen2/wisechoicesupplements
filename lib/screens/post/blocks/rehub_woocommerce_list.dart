import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/product/product.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';
import 'package:cirilla/extension/strings.dart';

class WoocommerceList extends StatefulWidget {
  final Map<String, dynamic>? block;

  const WoocommerceList({Key? key, this.block}) : super(key: key);

  @override
  State<WoocommerceList> createState() => _WoocommerceListState();
}

class _WoocommerceListState extends State<WoocommerceList> with Utility, BlockMixin, WishListMixin {
  void goDetail(BuildContext context, int productId) {
    Navigator.of(context).pushNamed(ProductScreen.routeName, arguments: {
      'id': productId,
    });
  }

  ///
  /// Handle wishlist
  void _wishlist(BuildContext context, int productId) {
    addWishList(productId: productId);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Map? attrs = get(widget.block, ['attrs'], {}) is Map ? get(widget.block, ['attrs'], {}) : {};
    List selectedPosts = get(attrs, ['selectedPosts'], []);
    List? offers = get(attrs, ['offers'], []);
    if (selectedPosts.isEmpty) {
      return Container();
    }
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        double screenWidth = MediaQuery.of(context).size.width;
        double width = maxWidth != double.infinity ? maxWidth : screenWidth;

        double widthImage = width;
        double heightImage = (widthImage * 180) / 337;

        return ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, int index) {
            dynamic id = selectedPosts[index];
            dynamic item = offers![index];

            String? image = get(item, ['thumbnail', 'url'], '');
            String title = get(item, ['title'], '');
            String copy = get(item, ['copy'], '');
            String? currentPrice = get(item, ['currentPrice'], '');
            String? oldPrice = get(item, ['oldPrice'], '');
            String button = get(item, ['addToCartText'], '');
            double score = ConvertData.stringToDouble(get(item, ['score'], 0));

            int productId = ConvertData.stringToInt(id);
            bool selectWishlist = existWishList(productId: productId);

            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: WoocommerceListItem(
                image: GestureDetector(
                  onTap: () => goDetail(context, productId),
                  child: Stack(
                    children: [
                      CirillaCacheImage(
                        image,
                        width: widthImage,
                        height: heightImage,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: score > 0
                            ? Padding(
                                padding: paddingTiny,
                                child: buildCircleNumber(number: score, theme: theme),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
                name: GestureDetector(
                  onTap: () => goDetail(context, productId),
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                price: oldPrice != currentPrice
                    ? Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(currentPrice!, style: theme.textTheme.titleSmall?.copyWith(color: ColorBlock.red)),
                          Text(
                            oldPrice!,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.textTheme.bodyMedium?.color,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      )
                    : Text(currentPrice!, style: theme.textTheme.titleSmall),
                description: copy.isNotEmpty ? Text(title, style: theme.textTheme.bodyMedium) : null,
                button: Column(
                  children: [
                    SizedBox(
                      height: 34,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(button.capitalizeFirstOfEach),
                        onPressed: () => goDetail(context, productId),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const InkWell(
                          child: Icon(FeatherIcons.shuffle, size: 16),
                        ),
                        SizedBox(
                          height: 18,
                          child: VerticalDivider(
                            width: 64,
                            color: theme.dividerColor,
                          ),
                        ),
                        InkWell(
                          onTap: () => _wishlist(context, productId),
                          child: Icon(selectWishlist ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, size: 16),
                        ),
                      ],
                    )
                  ],
                ),
                width: width,
                color: theme.cardColor,
              ),
            );
          },
          separatorBuilder: (_, int index) {
            return const SizedBox(height: 24);
          },
          itemCount: selectedPosts.length,
        );
      },
    );
  }
}
