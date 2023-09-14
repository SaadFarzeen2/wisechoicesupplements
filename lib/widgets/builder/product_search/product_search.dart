import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/search/product_search.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';

import 'icon_scan.dart';
import 'search_widget.dart';

class ProductSearchWidget extends StatelessWidget {
  final WidgetConfig? widgetConfig;

  const ProductSearchWidget({
    Key? key,
    this.widgetConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ProductSearchWidget(
      widgetConfig: widgetConfig,
      scan: (Color? color) => IconScan(color: color),
    );
  }
}

class _ProductSearchWidget extends SearchWidget {
  final WidgetConfig? widgetConfig;
  final Widget Function(Color?)? scan;

  const _ProductSearchWidget({
    Key? key,
    this.widgetConfig,
    this.scan,
  }) : super(
          key: key,
          widgetConfigData: widgetConfig,
          iconScan: scan,
        );

  @override
  void onPressed(BuildContext context) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    await showSearch<String?>(
      context: context,
      delegate: ProductSearchDelegate(context, translate),
    );
  }
}
