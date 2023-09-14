import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class CheckoutAddressBook extends StatefulWidget {
  final String valueSelected;
  final void Function(Map<String, dynamic>, String) onChanged;
  final AddressBook data;
  final String type;

  const CheckoutAddressBook({
    Key? key,
    required this.valueSelected,
    required this.onChanged,
    required this.data,
    this.type = 'billing',
  }) : super(key: key);

  @override
  State<CheckoutAddressBook> createState() => _CheckoutAddressBookState();
}

class _CheckoutAddressBookState extends State<CheckoutAddressBook> with Utility {
  late TextEditingController _controller;

  @override
  void didChangeDependencies() {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    List<AddressBookData>? data = widget.type == 'shipping' ? widget.data.shipping : widget.data.billing;
    AddressBookData? initAddress = data?.firstWhereOrNull((element) => element.name == widget.valueSelected);

    String text =
        initAddress != null ? getConvertAddress(initAddress.address ?? '') : translate('checkout_new_address');
    setState(() {
      _controller = TextEditingController(text: text);
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getConvertAddress(String text) {
    return text.replaceFirst('<br />', " : ").replaceAll('<br />', ", ");
  }

  AddressBookData getNewAddress(TranslateType translate) {
    List<AddressBookData>? dataList = widget.type == 'shipping' ? widget.data.shipping : widget.data.billing;
    Map<String, dynamic> data = dataList?.elementAt(0).data ?? {};
    Map<String, dynamic> value = {};

    if (data.isNotEmpty) {
      for (String key in data.keys) {
        if (key == 'country') {
          value[key] = data[key];
        } else {
          value[key] = '';
        }
      }
    }
    return AddressBookData(
      name: 'new',
      address: translate('checkout_new_address'),
      data: value,
    );
  }

  void openModal(TranslateType translate) async {
    List<AddressBookData>? dataList = widget.type == 'shipping' ? widget.data.shipping : widget.data.billing;

    if (dataList?.isNotEmpty == true) {
      AddressBookData? value = await showModalBottomSheet<AddressBookData?>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return buildViewModal(
            context,
            data: [
              ...dataList ?? [],
              getNewAddress(translate),
            ],
            visit: widget.valueSelected,
            onClick: (value) => Navigator.pop(context, value),
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
      );
      if (value != null) {
        _controller.text = getConvertAddress(value.address ?? '');
        widget.onChanged(value.data ?? {}, value.name ?? 'new');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: () => openModal(translate),
      decoration: InputDecoration(
        labelText: translate('checkout_input_address_book'),
        suffixIcon: const Padding(
          padding: EdgeInsetsDirectional.only(start: 16),
          child: Icon(FeatherIcons.chevronDown, size: 16),
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 2,
          minHeight: 2,
        ),
      ),
    );
  }

  Widget buildViewModal(
    BuildContext context, {
    required List<AddressBookData> data,
    required String visit,
    required ValueChanged<AddressBookData?> onClick,
  }) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height - mediaQuery.viewInsets.bottom;

    ThemeData theme = Theme.of(context);
    TextStyle? titleStyle = theme.textTheme.bodyMedium;
    TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);

    return Container(
      constraints: BoxConstraints(maxHeight: height - 100),
      padding: paddingHorizontal.add(paddingVerticalLarge),
      margin: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: data.isNotEmpty == true
              ? List.generate(data.length, (index) {
                  AddressBookData item = data[index];
                  bool isSelected = item.name == visit;

                  return CirillaTile(
                    title:
                        Text(getConvertAddress(item.address ?? ''), style: isSelected ? activeTitleStyle : titleStyle),
                    trailing: isSelected ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
                    isChevron: false,
                    onTap: () => onClick(!isSelected ? item : null),
                  );
                })
              : [],
        ),
      ),
    );
  }
}
