import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/product/add_on/model.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import 'helper.dart';

class MultipleChoice extends StatelessWidget {
  final List options;
  final Function(AddOnData) onChange;
  final AddOnData? value;
  final String type;
  final bool showPrice;
  final bool showDuration;
  final bool required;
  final String? error;

  const MultipleChoice({
    Key? key,
    required this.options,
    required this.onChange,
    this.value,
    this.type = 'select',
    this.showPrice = false,
    this.showDuration = false,
    this.required = false,
    this.error,
  }) : super(key: key);

  _onChange(dynamic data) {
    onChange(data);
  }

  @override
  Widget build(BuildContext context) {
    if (type == 'radiobutton') {
      return _ViewRadioButton(
        options: options,
        value: value,
        onChange: _onChange,
        showPrice: showPrice,
        showDuration: showDuration,
        error: error,
      );
    }

    if (type == 'images') {
      return _ViewImage(
        options: options,
        value: value,
        onChange: _onChange,
        showPrice: showPrice,
        showDuration: showDuration,
        error: error,
      );
    }
    return _ViewDropdown(
      options: options,
      value: value,
      onChange: _onChange,
      showPrice: showPrice,
      showDuration: showDuration,
      required: required,
      error: error,
    );
  }
}

class _ViewDropdown extends StatefulWidget {
  final List options;
  final Function(AddOnData) onChange;
  final AddOnData? value;
  final bool showPrice;
  final bool showDuration;
  final bool required;
  final String? error;

  const _ViewDropdown({
    Key? key,
    required this.options,
    required this.onChange,
    this.value,
    this.showPrice = false,
    this.showDuration = false,
    this.required = false,
    this.error,
  }) : super(key: key);

  @override
  State<_ViewDropdown> createState() => _ViewDropdownState();
}

class _ViewDropdownState extends State<_ViewDropdown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    AddOnOption? value = widget.value?.option;

    String text = widget.required ? translate('product_select_option') : translate('product_none');
    if (value != null) {
      dynamic option = widget.options.firstWhereOrNull((element) => widget.options.indexOf(element) == value.visit);
      text = getTextField(option);
    }

    if (text.isNotEmpty) {
      _controller.text = text;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  String getTextField(dynamic option) {
    String data = '';
    if (option is Map) {
      TranslateType translate = AppLocalizations.of(context)!.translate;
      String label = get(option, ['label'], '');
      String price = getTextPrice(context, option: option);
      String duration = getTextDuration(context, option: option, translate: translate);

      data = label;
      if (widget.showPrice && price.isNotEmpty) {
        data += ' (+$price)';
      }
      if (widget.showDuration && duration.isNotEmpty) {
        data += ' $duration';
      }
    }

    return data;
  }

  @override
  void didUpdateWidget(covariant _ViewDropdown oldWidget) {
    if (widget.value != oldWidget.value) {
      TranslateType translate = AppLocalizations.of(context)!.translate;
      String text = widget.required ? translate('product_select_option') : translate('product_none');
      String textOld = oldWidget.required ? translate('product_select_option') : translate('product_none');

      AddOnOption? value = widget.value?.option;
      AddOnOption? oldValue = oldWidget.value?.option;

      if (value != null) {
        dynamic option = widget.options.firstWhereOrNull((element) => widget.options.indexOf(element) == value.visit);
        text = getTextField(option);
      }

      if (oldValue != null) {
        dynamic oldOption =
            oldWidget.options.firstWhereOrNull((element) => oldWidget.options.indexOf(element) == oldValue.visit);
        textOld = getTextField(oldOption);
      }

      if (text != textOld) {
        _controller.text = text;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void showOption(BuildContext context) async {
    if (!_focusNode.hasPrimaryFocus) {
      _focusNode.unfocus();
    }
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    TextStyle? titleStyle = theme.textTheme.titleSmall;
    TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);

    AddOnOption? value = widget.value?.option;

    int? visit = await showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        MediaQueryData mediaQuery = MediaQuery.of(context);

        return Container(
          constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.5),
          child: buildViewModal(
            title: translate('product_select_options'),
            child: Column(
              children: [
                CirillaTile(
                  title: Text(widget.required ? translate('product_select_option') : translate('product_none'),
                      style: value == null ? activeTitleStyle : titleStyle),
                  trailing: value == null ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
                  isChevron: false,
                  onTap: () {
                    Navigator.pop(context, -1);
                  },
                ),
                ...List.generate(widget.options.length, (index) {
                  dynamic option = widget.options[index];
                  return CirillaTile(
                    title: Text(getTextField(option), style: index == value?.visit ? activeTitleStyle : titleStyle),
                    trailing:
                        index == value?.visit ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
                    isChevron: false,
                    onTap: () {
                      Navigator.pop(context, index);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
    );
    if (visit != null) {
      dynamic option = visit >= 0 ? widget.options[visit] : null;
      _onChange(option, visit);
    }
  }

  void _onChange(dynamic option, int visit) {
    AddOnOption? value;

    if (option != null) {
      String priceType = get(option, ['price_type'], 'flat_fee');
      double price = getPrice(context, option: option);

      String durationType = get(option, ['duration_type'], 'flat_time');
      double duration = getDuration(context, option: option);
      String sanitizeLabel = get(option, ['sanitize_label'], '');

      value = AddOnOption(
        visit: visit,
        value: '$sanitizeLabel-${visit + 1}',
        price: price,
        duration: duration,
        priceType: priceType,
        durationType: durationType,
      );
    }

    widget.onChange(
      AddOnData(type: AddOnDataType.option, option: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      onTap: () => showOption(context),
      decoration: InputDecoration(errorText: widget.error, suffixIcon: const Icon(Icons.keyboard_arrow_down)),
      textAlignVertical: TextAlignVertical.center,
    );
  }

  Widget buildViewModal({required String title, Widget? child}) {
    ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: height / 2),
      padding: paddingHorizontal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: itemPaddingMedium, bottom: itemPaddingLarge),
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
          Flexible(child: SingleChildScrollView(child: child))
        ],
      ),
    );
  }
}

class _ViewRadioButton extends StatelessWidget with Utility {
  final List options;
  final Function(AddOnData) onChange;
  final AddOnData? value;
  final bool showPrice;
  final bool showDuration;
  final String? error;

  const _ViewRadioButton({
    Key? key,
    required this.options,
    required this.onChange,
    this.value,
    this.showPrice = false,
    this.showDuration = false,
    this.error,
  }) : super(key: key);

  Widget buildTrailing({
    String price = '',
    String duration = '',
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (price.isNotEmpty) Text('+$price'),
        if (price.isNotEmpty && duration.isNotEmpty) const SizedBox(width: 10),
        if (duration.isNotEmpty) Text(duration),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    List<AddOnOption>? data = value?.listOption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(options.length, (index) {
          Map<String, dynamic> option = options[index];
          String label = option['label'] ?? '';
          String priceText = getTextPrice(context, option: option);
          String durationText = getTextDuration(context, option: option, translate: translate);

          bool isSelect =
              data?.isNotEmpty == true ? data!.where((element) => element.visit == index).toSet().isNotEmpty : false;
          return CirillaTile(
            leading: CirillaRadio(isSelect: isSelect),
            title: Text(label),
            trailing: (showPrice && priceText.isNotEmpty) || (showDuration && durationText.isNotEmpty)
                ? buildTrailing(price: priceText, duration: durationText)
                : null,
            onTap: () {
              String priceType = get(option, ['price_type'], 'flat_fee');
              double price = getPrice(context, option: option);

              String durationType = get(option, ['duration_type'], 'flat_time');
              double duration = getDuration(context, option: option);

              String sanitizeLabel = get(option, ['sanitize_label'], '');

              onChange(
                AddOnData(
                  type: AddOnDataType.listOption,
                  listOption: [
                    AddOnOption(
                      visit: index,
                      value: sanitizeLabel,
                      price: price,
                      duration: duration,
                      priceType: priceType,
                      durationType: durationType,
                    ),
                  ],
                ),
              );
            },
            pad: 10,
            isChevron: false,
          );
        }),
        if (error != null) ...[
          const SizedBox(height: itemPadding),
          Text(error ?? '', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
        ],
      ],
    );
  }
}

class _ViewImage extends StatelessWidget {
  final List options;
  final Function(AddOnData) onChange;
  final AddOnData? value;
  final bool showPrice;
  final bool showDuration;
  final String? error;

  const _ViewImage({
    Key? key,
    required this.options,
    required this.onChange,
    this.value,
    this.showPrice = false,
    this.showDuration = false,
    this.error,
  }) : super(key: key);

  void _onChange(BuildContext context, dynamic option, int visit) {
    String label = get(option, ['label'], '');

    String priceType = get(option, ['price_type'], 'flat_fee');
    double price = getPrice(context, option: option);

    String durationType = get(option, ['duration_type'], 'flat_time');
    double duration = getDuration(context, option: option);

    String sanitizeLabel = get(option, ['sanitize_label'], '');

    onChange(
      AddOnData(
        type: AddOnDataType.option,
        option: AddOnOption(
          visit: visit,
          value: '$sanitizeLabel-${visit + 1}',
          label: label,
          price: price,
          duration: duration,
          priceType: priceType,
          durationType: durationType,
        ),
      ),
    );
  }

  Widget buildValueSelect({
    required AddOnOption data,
    String price = '',
    String duration = '',
  }) {
    return Wrap(
      spacing: 10,
      children: [
        Text(data.label ?? ''),
        if (price.isNotEmpty) Text('(+$price)'),
        if (duration.isNotEmpty) Text(duration),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    AddOnOption? data = value?.option;
    dynamic optionSelect =
        data?.visit != null && data!.visit >= 0 && data.visit < options.length ? options.elementAt(data.visit) : null;
    String price = optionSelect is Map ? getTextPrice(context, option: optionSelect) : '';
    String duration = optionSelect is Map ? getTextDuration(context, option: optionSelect, translate: translate) : '';

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(options.length, (index) {
                Map<String, dynamic> option = options[index];

                double padEnd = index < options.length - 1 ? itemPaddingSmall : 0;

                return Padding(
                  padding: EdgeInsetsDirectional.only(end: padEnd),
                  child: _ImageItem(
                    option: option,
                    isSelect: data?.visit == index,
                    onClick: () => _onChange(context, option, index),
                  ),
                );
              }),
            ),
          ),
          if (data?.visit != null) ...[
            const SizedBox(height: itemPadding),
            buildValueSelect(data: data!, price: price, duration: duration)
          ],
          if (error != null) ...[
            const SizedBox(height: itemPadding),
            Text(error ?? '', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
          ],
        ],
      ),
    );
  }
}

class _ImageItem extends StatefulWidget {
  final Map<String, dynamic> option;
  final bool isSelect;
  final GestureTapCallback? onClick;

  const _ImageItem({
    Key? key,
    required this.option,
    this.isSelect = false,
    this.onClick,
  }) : super(key: key);

  @override
  State<_ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<_ImageItem> with LoadingMixin {
  String _url = '';
  bool _loading = false;

  late SettingStore _settingStore;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    getUrl(widget.option);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _ImageItem oldWidget) {
    if (widget.option != oldWidget.option) {
      getUrl(widget.option);
    }
    super.didUpdateWidget(oldWidget);
  }

  void getUrl(Map<String, dynamic> option) {
    String idImage = get(widget.option, ['image'], '');
    if (idImage.isEmpty) {
      setState(() {
        _url = '';
        _loading = false;
      });
    } else {
      setState(() {
        _url = '';
        _loading = true;
      });
      getUrlMedia(idImage);
    }
  }

  void getUrlMedia(String idImage) async {
    try {
      Map? data = await _settingStore.requestHelper.getMedia(mediaId: idImage);
      String url = get(data, ['source_url'], '');
      setState(() {
        _url = url;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _url = '';
        _loading = false;
      });
    }
  }

  Widget buildImage() {
    if (_loading) {
      return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: iOSLoading(context, size: 10),
      );
    }
    return CirillaCacheImage(_url, width: 40, height: 40);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    BorderRadius borderRadius = BorderRadius.circular(8);
    Border border = widget.isSelect ? Border.all(color: theme.primaryColor) : Border.all(color: theme.dividerColor);

    return InkWell(
      onTap: widget.onClick,
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(borderRadius: borderRadius, border: border),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: buildImage(),
        ),
      ),
    );
  }
}
