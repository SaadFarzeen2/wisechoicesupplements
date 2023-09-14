import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class Refine extends StatefulWidget {
  final String? search;
  final double? rangeDistance;
  final List<ProductCategory>? categories;
  final bool enableRange;
  final Function(String search, double? rangeDistance, List<ProductCategory>? categories)? onSubmit;

  const Refine({
    Key? key,
    this.search,
    this.rangeDistance,
    this.categories,
    this.enableRange = false,
    this.onSubmit,
  }) : super(key: key);

  @override
  State<Refine> createState() => _RefineState();
}

class _RefineState extends State<Refine> {
  TextEditingController? _txtSearch;
  double _rangeDistance = 50;
  List<ProductCategory>? _categories;
  late ProductCategoryStore _productCategoryStore;
  bool isExpand = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productCategoryStore = Provider.of<ProductCategoryStore>(context);
  }

  @override
  void initState() {
    super.initState();
    _txtSearch = TextEditingController(text: widget.search ?? '');
    _rangeDistance = widget.rangeDistance ?? 50;
    _categories = widget.categories;
  }

  @override
  void dispose() {
    _txtSearch?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        List<ProductCategory> categories = _productCategoryStore.categories;
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Padding(
            padding: paddingHorizontal,
            child: Column(
              children: [
                Container(
                  padding: paddingVerticalMedium,
                  child: Stack(
                    children: [
                      Center(child: Text(translate('refine'), style: theme.textTheme.titleMedium)),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              _txtSearch!.clear();
                              setState(() {
                                _rangeDistance = 50;
                                _categories = null;
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: theme.textTheme.bodySmall?.color,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              textStyle: theme.textTheme.bodySmall,
                            ),
                            child: Text(translate('clear_all')),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _txtSearch,
                        decoration: InputDecoration(
                          labelText: translate('vendor_refine_search'),
                          prefixIcon: const Icon(
                            FeatherIcons.search,
                            size: 16,
                          ),
                        ),
                      ),
                      if (widget.enableRange) ...[
                        const SizedBox(height: 24),
                        Text(translate('vendor_refine_range'), style: theme.textTheme.titleSmall),
                        Row(
                          children: [
                            Text(translate('vendor_refine_distance', {'distance': '0'})),
                            Expanded(
                              child: Slider(
                                value: _rangeDistance,
                                onChanged: (double value) => setState(
                                  () {
                                    _rangeDistance = value;
                                  },
                                ),
                                max: 100,
                                min: 0,
                                divisions: 50,
                                label: _rangeDistance.round().toString(),
                              ),
                            ),
                            Text(translate('vendor_refine_distance', {'distance': '100'})),
                          ],
                        ),
                      ],
                      CirillaTile(
                        title: Text(translate('categories'), style: theme.textTheme.titleSmall),
                        trailing: _IconButton(active: isExpand),
                        isChevron: false,
                        onTap: () => setState(() {
                          isExpand = !isExpand;
                        }),
                      ),
                      if (isExpand)
                        ...List.generate(categories.length, (index) {
                          ProductCategory category = categories.elementAt(index);

                          return Padding(
                            padding: const EdgeInsetsDirectional.only(start: 32),
                            child: _ItemCategory(
                              category: category,
                              selectCategories: _categories,
                              onChange: (ProductCategory value, bool isSelect) => setState(() {
                                if (!isSelect) {
                                  _categories = [
                                    ...?_categories,
                                    value,
                                  ];
                                } else {
                                  List<ProductCategory>? data = _categories;
                                  data?.removeWhere((element) => element.id == value.id);
                                  _categories = data;
                                }
                              }),
                            ),
                          );
                        })
                    ],
                  ),
                ),
                Padding(
                  padding: paddingVerticalLarge,
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      child: Text(translate('apply')),
                      onPressed: () => widget.onSubmit!(_txtSearch!.text, _rangeDistance, _categories),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ItemCategory extends StatefulWidget {
  final ProductCategory? category;
  final List<ProductCategory>? selectCategories;
  final Function(ProductCategory value, bool isSelect)? onChange;

  const _ItemCategory({
    Key? key,
    this.category,
    this.selectCategories,
    this.onChange,
  }) : super(key: key);

  @override
  _ItemCategoryState createState() => _ItemCategoryState();
}

class _ItemCategoryState extends State<_ItemCategory> {
  bool isExpand = true;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ProductCategory category = widget.category!;
    bool isSelect = widget.selectCategories?.firstWhereOrNull((element) => element.id == category.id) != null;
    Color? textColor = isSelect ? theme.textTheme.titleMedium?.color : null;

    return Column(
      children: [
        CirillaTile(
          leading: CirillaRadio(isSelect: isSelect),
          title: Text(category.name!, style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
          trailing: category.categories!.isNotEmpty
              ? _IconButton(
                  active: isExpand,
                  onPressed: () => setState(() {
                    isExpand = !isExpand;
                  }),
                )
              : null,
          isChevron: false,
          onTap: () => widget.onChange?.call(category, isSelect),
        ),
        if (isExpand)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 32),
            child: Column(
              children: List.generate(category.categories!.length, (index) {
                ProductCategory? categoryChild = category.categories!.elementAt(index);
                return _ItemCategory(
                  category: categoryChild,
                  selectCategories: widget.selectCategories,
                  onChange: widget.onChange,
                );
              }),
            ),
          )
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final Function? onPressed;
  final bool active;

  const _IconButton({Key? key, this.onPressed, this.active = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).textTheme.displayLarge?.color;
    Color activeColor = Theme.of(context).primaryColor;
    return IconButton(
      icon: Icon(
        active ? FeatherIcons.chevronDown : FeatherIcons.chevronRight,
        color: active ? activeColor : color,
        size: 16,
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}
