import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/product/variation_store.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ProductVariable extends StatelessWidget with LoadingMixin {
  final Product? product;
  final VariationStore? store;
  final TextAlign alignTitle;

  const ProductVariable({Key? key, this.product, this.store, this.alignTitle = TextAlign.start}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (store!.data == null) {
        return buildLoading(
          context,
          isLoading: store!.loading,
        );
      }

      Map<String, String> labels = store!.data!['attribute_labels'] ?? {};

      return Stack(
        children: [
          ListView.separated(
            itemBuilder: (_, int index) {
              return Attr(
                id: labels.keys.elementAt(index),
                label: labels[labels.keys.elementAt(index)],
                store: store,
                alignTitle: alignTitle,
              );
            },
            separatorBuilder: (_, int index) {
              return const SizedBox(height: 24);
            },
            itemCount: labels.keys.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: 0,
            end: 0,
            child: InkWell(
              onTap: store!.clear,
              child: Text(
                AppLocalizations.of(context)!.translate('product_clear_all'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class Attr extends StatelessWidget {
  final String? id;
  final String? label;
  final VariationStore? store;
  final TextAlign alignTitle;

  const Attr({Key? key, this.id, this.label, this.store, this.alignTitle = TextAlign.start}) : super(key: key);

  bool checkExistTermVariation(String? id, String option) {
    return store!.data!['variations'].any((element) {
      Map<String, String> attributes = Map<String, String>.from(element['attributes']);
      return attributes.keys.every((el) {
        String key = el.toLowerCase();
        return key == id && attributes[key] == option;
      });
    });
  }

  bool check(String option) {
    if (store!.selected.isEmpty) return true;

    // Pre data if select the term
    Map<String?, String?> selected = Map<String?, String?>.of(store!.selected);
    if (selected.containsKey(id)) {
      selected.update(id, (value) => option);
    } else {
      selected.putIfAbsent(id, () => option);
    }

    return store!.data!['variations'].any((element) {
      Map<String, String> attributes = Map<String, String>.from(element['attributes']);
      return selected.keys.every(
        (el) {
          String key = el!.toLowerCase();
          return attributes[key] == null || attributes[key] == '' || attributes[key] == selected[el];
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Observer(
      builder: (_) {
        Map<String, List<String>> terms = store!.data!['attribute_terms'];
        Map<String, String>? labels = store!.data!['attribute_terms_labels'];
        Map<String, Map<String, String>>? values = store!.data!['attribute_terms_values'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              alignment: AlignmentDirectional.centerStart,
              child: RichText(
                textAlign: alignTitle,
                text: TextSpan(text: '$label: ', style: theme.textTheme.bodyMedium, children: [
                  if (store!.selected[id] != null)
                    TextSpan(
                      text: labels!['${id}_${store!.selected[id]}'],
                    )
                ]),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 38,
              child: buildTerm(terms, labels, values),
            ),
          ],
        );
      },
    );
  }

  Widget buildTerm(
      Map<String, List<String>> terms, Map<String, String>? labels, Map<String, Map<String, String>>? values) {
    List<String> term = get(terms, [id], []) ?? [];
    List<String> newTerm = term.where((e) => checkExistTermVariation(id, e)).toList();

    if (newTerm.isEmpty) {
      return Container();
    }

    return ListView.separated(
      itemCount: newTerm.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        String nameTerm = newTerm[index];
        return Term(
          label: labels!['${id}_$nameTerm'],
          value: values != null ? values['${id}_$nameTerm'] : null,
          option: nameTerm,
          isSelected: nameTerm == store!.selected[id],
          canSelect: check(nameTerm),
          onSelectTerm: () => store!.selectTerm(key: id, value: nameTerm),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 10),
    );
  }
}

class Term extends StatelessWidget {
  final String? option;
  final String? label;
  final bool? isSelected;
  final bool canSelect;
  final Function? onSelectTerm;
  final Map? value;

  const Term({
    Key? key,
    this.option,
    this.label,
    this.isSelected,
    this.onSelectTerm,
    required this.canSelect,
    this.value,
  }) : super(key: key);

  Container boxCircle({
    double? size,
    Color? color,
    Border? border,
  }) {
    return Container(
      width: size ?? 39,
      height: size ?? 39,
      decoration: BoxDecoration(
        color: color,
        border: border,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget buildColor({ThemeData? theme}) {
    Color? color = ConvertData.fromHex(value!['value'], Colors.transparent);

    Widget child = Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: boxCircle(color: color, size: 27),
        ),
        isSelected!
            ? boxCircle(
                border: Border.all(width: 2, color: theme!.primaryColor),
              )
            : boxCircle(
                border: Border.all(color: theme!.dividerColor),
              )
      ],
    );
    return GestureDetector(
      onTap: !canSelect ? null : onSelectTerm as void Function()?,
      child: Opacity(
        opacity: canSelect ? 1 : 0.6,
        child: child,
      ),
    );
  }

  Widget buildImage({ThemeData? theme}) {
    return InkWell(
      onTap: !canSelect ? null : onSelectTerm as void Function()?,
      child: Opacity(
        opacity: canSelect ? 1 : 0.6,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(value!['value']),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
            border: isSelected! ? Border.all(width: 2, color: theme!.primaryColor) : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle? titleButton = theme.textTheme.bodyMedium;

    if (value != null && value!['type'] == 'color') return buildColor(theme: theme);
    if (value != null && value!['type'] == 'image') return buildImage(theme: theme);

    if (isSelected!) {
      return OutlinedButton(
        onPressed: onSelectTerm as void Function()?,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.primaryColor,
          side: BorderSide(width: 2, color: theme.primaryColor),
          textStyle: titleButton,
          minimumSize: const Size(40, 0),
          padding: paddingHorizontal,
        ),
        child: Text(label!),
      );
    }
    return OutlinedButton(
      onPressed: !canSelect ? null : onSelectTerm as void Function()?,
      style: OutlinedButton.styleFrom(
        foregroundColor: titleButton!.color,
        side: BorderSide(width: 1, color: theme.dividerColor),
        textStyle: titleButton,
        minimumSize: const Size(40, 0),
        padding: paddingHorizontal,
      ),
      child: Text(label!),
    );
  }
}
