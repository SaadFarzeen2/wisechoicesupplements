import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_product_item.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'layout/layout_list.dart';
import 'layout/layout_carousel.dart';
import 'layout/layout_masonry.dart';
import 'layout/layout_slideshow.dart';
import 'layout/layout_big_first.dart';
import 'layout/layout_grid.dart';

class ProductWidget extends StatelessWidget {
  final Map<String, dynamic>? fields;
  final Map<String, dynamic>? styles;
  final String? layout;
  final ProductsStore? productsStore;
  final EdgeInsetsDirectional padding;

  const ProductWidget({
    Key? key,
    this.styles = const {},
    this.fields = const {},
    this.layout,
    this.productsStore,
    this.padding = EdgeInsetsDirectional.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context);

    return Observer(builder: (_) {
      if (productsStore == null) return Container();

      String themeModeKey = settingStore.themeModeKey;

      bool loading = productsStore!.loading;
      List<Product> products = productsStore!.products;

      // Style
      double? height = ConvertData.stringToDoubleCanBeNull(get(styles, ['height'], null));

      // general config
      int limit = ConvertData.stringToInt(get(fields, ['limit'], 4));
      List<Product> emptyProducts = List.generate(limit, (index) => Product()).toList();
      bool isShimmer = products.isEmpty && loading;

      return SizedBox(
        height: layout != Strings.productLayoutCarousel && layout != Strings.productLayoutSlideshow ? null : height,
        child: LayoutProductList(
          fields: fields,
          styles: styles,
          products: isShimmer ? emptyProducts : products,
          layout: layout,
          padding: padding,
          themeModeKey: themeModeKey,
          onLoadMore: () => productsStore!.getProducts(),
          canLoadMore: productsStore!.canLoadMore,
          loading: loading,
        ),
      );
    });
  }
}

class LayoutProductList extends StatefulWidget {
  final Map<String, dynamic>? fields;
  final Map<String, dynamic>? styles;
  final List<Product>? products;
  final String? layout;
  final EdgeInsetsDirectional padding;
  final String themeModeKey;
  final Function? onLoadMore;
  final bool canLoadMore;
  final bool loading;

  const LayoutProductList({
    Key? key,
    this.fields = const {},
    this.styles = const {},
    this.products,
    this.layout = Strings.productLayoutList,
    this.padding = EdgeInsetsDirectional.zero,
    this.themeModeKey = 'value',
    this.onLoadMore,
    this.canLoadMore = false,
    this.loading = false,
  }) : super(key: key);

  @override
  State<LayoutProductList> createState() => _LayoutProductListState();
}

class _LayoutProductListState extends State<LayoutProductList> with GeneralMixin {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      double widthView = constraints.maxWidth;
      return buildLayout(context, widthView);
    });
  }

  Widget buildLayout(BuildContext context, [double widthView = 300]) {
    // General config
    Map<String, dynamic>? templateItem = get(widget.fields, ['template'], {});
    bool? enableLoadMore = get(widget.fields, ['enableLoadMore'], false);
    double? width = ConvertData.stringToDouble(get(templateItem, ['data', 'size', 'width'], 100));
    double? height = ConvertData.stringToDouble(get(templateItem, ['data', 'size', 'height'], 100));
    int column = ConvertData.stringToInt(get(widget.styles, ['col'], 2), 2);
    double? ratio = ConvertData.stringToDouble(get(widget.styles, ['ratio'], 1), 1);

    // Styles config
    double? pad = ConvertData.stringToDouble(get(widget.styles, ['pad'], 0));
    double? dividerHeight = ConvertData.stringToDouble(get(widget.styles, ['dividerWidth'], 1));
    Color dividerColor =
        ConvertData.fromRGBA(get(widget.styles, ['dividerColor', widget.themeModeKey], {}), Colors.transparent);
    Color indicatorColor = ConvertData.fromRGBA(
      get(widget.styles, ['indicatorColor', widget.themeModeKey], {}),
      Theme.of(context).dividerColor,
    );
    Color indicatorActiveColor = ConvertData.fromRGBA(
      get(widget.styles, ['indicatorActiveColor', widget.themeModeKey], {}),
      Theme.of(context).primaryColor,
    );

    switch (widget.layout) {
      case Strings.productLayoutCarousel:
        return LayoutCarousel(
          products: widget.products,
          buildItem: _buildItem,
          pad: pad,
          dividerColor: dividerColor,
          dividerHeight: dividerHeight,
          padding: widget.padding,
          width: width,
          height: height,
          enableLoadMore: enableLoadMore,
          canLoadMore: widget.canLoadMore,
          onLoadMore: widget.onLoadMore,
          loading: widget.loading,
        );
      case Strings.productLayoutMasonry:
        return LayoutMasonry(
          products: widget.products,
          buildItem: _buildItem,
          pad: pad,
          dividerColor: dividerColor,
          dividerHeight: dividerHeight,
          padding: widget.padding,
          width: width,
          height: height,
          widthView: widthView,
          enableLoadMore: enableLoadMore,
          canLoadMore: widget.canLoadMore,
          onLoadMore: widget.onLoadMore,
          loading: widget.loading,
        );
      case Strings.productLayoutBigFirst:
        return LayoutBigFirst(
          products: widget.products,
          buildItem: _buildItem,
          pad: pad,
          dividerColor: dividerColor,
          dividerHeight: dividerHeight,
          template: templateItem,
          padding: widget.padding,
          widthView: widthView,
          enableLoadMore: enableLoadMore,
          canLoadMore: widget.canLoadMore,
          onLoadMore: widget.onLoadMore,
          loading: widget.loading,
        );
      case Strings.productLayoutSlideshow:
        return LayoutSlideshow(
          products: widget.products,
          buildItem: _buildItem,
          width: width,
          height: height,
          padding: widget.padding,
          indicatorColor: indicatorColor,
          indicatorActiveColor: indicatorActiveColor,
          widthView: widthView,
        );
      case Strings.productLayoutGrid:
        return LayoutGrid(
          products: widget.products,
          buildItem: _buildItem,
          width: width,
          height: height,
          padding: widget.padding,
          column: column,
          ratio: ratio,
          pad: pad,
          widthView: widthView,
          dividerHeight: dividerHeight,
          dividerColor: dividerColor,
          enableLoadMore: enableLoadMore,
          canLoadMore: widget.canLoadMore,
          onLoadMore: widget.onLoadMore,
          loading: widget.loading,
        );
      default:
        return LayoutList(
          products: widget.products,
          buildItem: _buildItem,
          pad: pad,
          dividerColor: dividerColor,
          dividerHeight: dividerHeight,
          padding: widget.padding,
          width: width,
          height: height,
          widthView: widthView,
          enableLoadMore: enableLoadMore,
          canLoadMore: widget.canLoadMore,
          onLoadMore: widget.onLoadMore,
          loading: widget.loading,
        );
    }
  }

  Widget _buildItem(
    BuildContext context, {
    Product? product,
    double width = 100,
    double height = 100,
  }) {
    ThemeData theme = Theme.of(context);
    // Template
    String? template = get(widget.fields, ['template', 'template'], Strings.productItemContained);
    Map<String, dynamic>? dataTemplate = get(widget.fields, ['template', 'data'], {});

    Color backgroundColor =
        ConvertData.fromRGBA(get(widget.styles, ['backgroundColorItem', widget.themeModeKey], {}), theme.cardColor);
    Color textColor = ConvertData.fromRGBA(
        get(widget.styles, ['textColor', widget.themeModeKey], {}), theme.textTheme.titleMedium?.color);
    Color subTextColor = ConvertData.fromRGBA(
        get(widget.styles, ['subTextColor', widget.themeModeKey], {}), theme.textTheme.bodySmall?.color);
    Color priceColor = ConvertData.fromRGBA(
        get(widget.styles, ['priceColor', widget.themeModeKey], {}), theme.textTheme.titleMedium?.color);
    Color salePriceColor =
        ConvertData.fromRGBA(get(widget.styles, ['salePriceColor', widget.themeModeKey], {}), ColorBlock.red);
    Color regularPriceColor = ConvertData.fromRGBA(
        get(widget.styles, ['regularPriceColor', widget.themeModeKey], {}), theme.textTheme.bodySmall?.color);
    Map wishlist = get(widget.styles, ['wishlistColor', widget.themeModeKey], {});
    Color? wishlistColor = wishlist.isNotEmpty ? ConvertData.fromRGBA(wishlist, Colors.black) : null;

    Color labelNewColor =
        ConvertData.fromRGBA(get(widget.styles, ['labelNewColor', widget.themeModeKey], {}), ColorBlock.green);
    Color labelNewTextColor =
        ConvertData.fromRGBA(get(widget.styles, ['labelNewTextColor', widget.themeModeKey], {}), Colors.white);
    double? radiusLabelNew = ConvertData.stringToDouble(get(widget.styles, ['radiusLabelNew'], 10));
    Color labelSaleColor =
        ConvertData.fromRGBA(get(widget.styles, ['labelSaleColor', widget.themeModeKey], {}), ColorBlock.red);
    Color labelSaleTextColor =
        ConvertData.fromRGBA(get(widget.styles, ['labelSaleTextColor', widget.themeModeKey], {}), Colors.white);
    double? radiusLabelSale = ConvertData.stringToDouble(get(widget.styles, ['radiusLabelSale'], 10));

    double? radius = ConvertData.stringToDouble(get(widget.styles, ['radius'], 0));
    double? radiusImage = ConvertData.stringToDouble(get(widget.styles, ['radiusImage'], 8));

    String? typeCart = get(widget.styles, ['typeCart'], 'elevated');
    double? radiusCart = ConvertData.stringToDouble(get(widget.styles, ['radiusCart'], 8));
    Map? iconCart = get(widget.styles, ['iconCart'], {'name': 'plus', 'type': 'feather'});

    bool enableIconCart = get(widget.styles, ['enableIconCart'], true);
    Map? paddingItem = get(widget.styles, ['paddingItem'], {});

    Color shadowColor =
        ConvertData.fromRGBA(get(widget.styles, ['shadowColor', widget.themeModeKey], {}), Colors.transparent);
    double offsetX = ConvertData.stringToDouble(get(widget.styles, ['offsetX'], 0));
    double offsetY = ConvertData.stringToDouble(get(widget.styles, ['offsetY'], 4));
    double blurRadius = ConvertData.stringToDouble(get(widget.styles, ['blurRadius'], 24));
    double spreadRadius = ConvertData.stringToDouble(get(widget.styles, ['spreadRadius'], 0));

    EdgeInsetsDirectional padding = ConvertData.space(paddingItem, 'paddingItem');

    BoxShadow shadow = backgroundColor.opacity > 0
        ? BoxShadow(
            color: shadowColor,
            offset: Offset(offsetX, offsetY),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          )
        : BoxShadow(
            color: shadowColor,
            offset: Offset(offsetX, 0),
            blurRadius: blurRadius + 2 * offsetY,
            spreadRadius: spreadRadius,
            blurStyle: BlurStyle.outer,
          );

    return CirillaProductItem(
      product: product,
      width: width,
      height: height,
      template: template,
      dataTemplate: dataTemplate,
      background: backgroundColor,
      textColor: textColor,
      subTextColor: subTextColor,
      priceColor: priceColor,
      salePriceColor: salePriceColor,
      regularPriceColor: regularPriceColor,
      wishlistColor: wishlistColor,
      labelNewColor: labelNewColor,
      labelNewTextColor: labelNewTextColor,
      labelNewRadius: radiusLabelNew,
      labelSaleColor: labelSaleColor,
      labelSaleTextColor: labelSaleTextColor,
      labelSaleRadius: radiusLabelSale,
      radius: radius,
      radiusImage: radiusImage,
      boxShadow: [shadow],
      iconAddCart: getIconData(data: iconCart),
      radiusAddCart: radiusCart,
      outlineAddCart: typeCart == 'outline',
      padding: padding,
      enableIconCart: enableIconCart,
    );
  }
}
