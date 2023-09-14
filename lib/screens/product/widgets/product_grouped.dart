import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/product/product_type.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_quantity.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

import '../product.dart';

class ProductTypeGrouped extends StatefulWidget {
  final Product? product;

  final Map<int?, int>? qty;
  final Function? onChanged;

  const ProductTypeGrouped({Key? key, this.product, this.qty, this.onChanged}) : super(key: key);

  @override
  State<ProductTypeGrouped> createState() => _ProductTypeGroupedState();
}

class _ProductTypeGroupedState extends State<ProductTypeGrouped> with ProductMixin, ShapeMixin {
  late ProductsStore _productsStore;

  @override
  void didChangeDependencies() {
    RequestHelper requestHelper = Provider.of<RequestHelper>(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);

    _productsStore = ProductsStore(
      requestHelper,
      include: widget.product!.groupedIds!.map((e) => Product(id: e)).toList(),
      currency: settingStore.currency,
      language: settingStore.locale,
    )..getProducts();

    super.didChangeDependencies();
  }

  ///
  /// Handle navigate
  void _navigate(BuildContext context, Product product) {
    if (product.id == null) {
      return;
    }
    Navigator.pushNamed(
      context,
      '${ProductScreen.routeName}/${product.id}/${product.slug}',
      arguments: {'product': product},
    );
  }

  void buildModalEmpty(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      shape: borderRadiusTop(),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: paddingHorizontal.copyWith(top: itemPaddingMedium, bottom: itemPaddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                translate('product_quantity_min', {'min': '0'}),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context), child: Text(translate('product_quantity_agree'))),
              ),
            ],
          ),
        );
      },
    );
    future.then((void value) {
      widget.onChanged!(product: widget.product, qty: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (widget.product!.groupedIds!.isEmpty) return Container();

    List<Product> loadingProduct = List.generate(widget.product!.groupedIds!.length, (index) => Product()).toList();

    return ClipRRect(
      borderRadius: borderRadius,
      child: Observer(
        builder: (_) {
          List<Product> products = _productsStore.loading ? loadingProduct : _productsStore.products;
          return Column(
            children: List.generate(products.length, (index) {
              Product product = products[index];
              return Padding(
                padding: EdgeInsets.only(bottom: index < loadingProduct.length - 1 ? 1 : 0),
                child: ProductGroupedItem(
                  name: buildName(context, product: product, style: theme.textTheme.bodyMedium),
                  quantity: buildQuantity(context, product: product, theme: theme),
                  price: buildPrice(context, product: product),
                  onClick: () => _navigate(context, product),
                  color: theme.dividerColor,
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget buildQuantity(
    BuildContext context, {
    required Product product,
    ThemeData? theme,
    double shimmerWidth = 87,
    double shimmerHeight = 28,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }
    if (product.type != productTypeSimple) {
      return SizedBox(
        width: shimmerWidth,
        child: ElevatedButton(
            onPressed: () => {}, child: Text(AppLocalizations.of(context)!.translate('product_select_options'))),
      );
    }
    return CirillaQuantity(
      onChanged: (value) {
        widget.onChanged!(product: product, qty: value);
      },
      value: widget.qty![product.id] ?? 0,
      height: shimmerHeight,
      width: shimmerWidth,
      color: theme!.scaffoldBackgroundColor,
      borderColor: theme.dividerColor,
      min: 0,
    );
  }
}
