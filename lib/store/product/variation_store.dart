import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/currencies.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/models/product/product_variable.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'variation_store.g.dart';

class VariationStore = VariationStoreBase with _$VariationStore;

abstract class VariationStoreBase with Store {
  final String? key;
  final RequestHelper? _requestHelper;

  // constructor: ------------------------------------------------------------------------------------------------------
  VariationStoreBase(this._requestHelper, {this.key, int? productId, String? lang, String? currency}) {
    _productId = productId;
    if (lang != null && lang != '') _lang = lang;
    if (lang != currency && currency != '') _currency = currency;
  }

  // store variables: --------------------------------------------------------------------------------------------------
  @observable
  String _lang = defaultLanguage;

  @observable
  String? _currency = '';

  @observable
  int? _productId;

  @observable
  ObservableMap<String?, String?> _selected = ObservableMap<String?, String?>.of({});

  @observable
  ObservableMap<String, dynamic>? _data;

  @observable
  bool _loading = false;

  // computed: ---------------------------------------------------------------------------------------------------------

  // Get product variation info
  @computed
  ObservableMap<String, dynamic>? get data => _data;

  // Get term selected
  @computed
  ObservableMap<String?, String?> get selected => _selected;

  @computed
  bool get loading => _loading;

  @computed
  bool get canAddToCart =>
      _data != null && _selected.keys.isNotEmpty && _selected.keys.length == _data!['attribute_ids'].keys.length;

  @computed
  Map<String, dynamic> get findVariation => canAddToCart
      ? _data!['variations']?.firstWhere((e) {
          Map<String, String> attributes = Map<String, String>.from(e['attributes']);
          return _selected.keys.every(
            (el) {
              String key = el!.toLowerCase();
              return attributes[key] == null || attributes[key] == '' || attributes[key] == _selected[el];
            },
          );
        }, orElse: () => {'id': 0})
      : {'id': 0};

  @computed
  Product? get productVariation => findVariation['id'] > 0 ? Product.fromVariation(findVariation) : null;

  // actions: ----------------------------------------------------------------------------------------------------------
  @action
  void selectTerm({String? key, String? value}) {
    String dataValue = value ?? '';
    if (dataValue.isNotEmpty) {
      if (_selected.containsKey(key ?? -1)) {
        _selected.update(key, (v) => dataValue);
      } else {
        _selected.putIfAbsent(key, () => dataValue);
      }
    }
  }

  @action
  void clear() {
    _selected = ObservableMap<String?, String?>.of({});
  }

  @action
  Future<void> getVariation(List<Map<String, dynamic>>? defaultAttributes) async {
    _loading = true;
    try {
      Map<String, dynamic> qs = {
        'product_id': _productId,
        'lang': _lang,
        CURRENCY_PARAM: _currency,
      };
      ProductVariable res = await _requestHelper!.getProductVariations(queryParameters: preQueryParameters(qs));
      Map<String?, String?> selectData = {};

      Map<String, dynamic> data = res.toJson();

      _data = ObservableMap<String, dynamic>.of(data);
      if (defaultAttributes?.isNotEmpty == true) {
        for (var att in defaultAttributes!) {
          int idAttr = ConvertData.stringToInt(att['id']);
          String valueAttr = att['option'];
          String? keyAttr = res.ids?.keys.firstWhere((k) => res.ids?[k] == idAttr);
          if (keyAttr != null) {
            selectData.addAll({
              keyAttr: valueAttr,
            });
          }
        }

        Map<String, dynamic>? variationSelected = data['variations']?.firstWhere((e) {
          Map<String, String> attributes = Map<String, String>.from(e['attributes']);
          return selectData.keys.every(
            (el) {
              String key = el!.toLowerCase();
              return attributes[key] == null || attributes[key] == '' || attributes[key] == selectData[el];
            },
          );
        }, orElse: () => {"id": null});

        dynamic id = variationSelected?['id'];
        if (id == null) {
          selectData.clear();
          dynamic variation = data['variations']?[0];

          if (variation is Map && variation['attributes'] is Map) {
            selectData = Map.castFrom<dynamic, dynamic, String?, String?>(variation['attributes']);
          }
        }
      }
      _selected = ObservableMap<String?, String?>.of(selectData);
      _loading = false;
    } on DioError {
      _loading = false;
      rethrow;
    }
  }

  // dispose: ----------------------------------------------------------------------------------------------------------
  @action
  dispose() {}
}
