import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/models/product/staff_model.dart';
import 'package:cirilla/screens/product/add_on/label.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:collection/collection.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class MenuStaff extends StatelessWidget {
  const MenuStaff({
    Key? key,
    required this.listStaff,
    required this.dropdownValue,
    required this.staffLabel,
    required this.onChange,
  }) : super(key: key);

  final String staffLabel;
  final StaffModel dropdownValue;
  final List<StaffModel> listStaff;
  final Function(StaffModel? staff) onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelField(label: staffLabel),
        const SizedBox(height: itemPaddingSmall),
        _ViewDropdown(
          value: dropdownValue,
          options: listStaff,
          onChange: onChange,
          titleSelect: staffLabel,
        ),
      ],
    );
  }
}

class _ViewDropdown extends StatefulWidget {
  final List<StaffModel> options;
  final Function(StaffModel) onChange;
  final StaffModel? value;
  final String? titleSelect;

  const _ViewDropdown({
    Key? key,
    required this.options,
    required this.onChange,
    this.value,
    this.titleSelect,
  }) : super(key: key);

  @override
  State<_ViewDropdown> createState() => _ViewDropdownState();
}

class _ViewDropdownState extends State<_ViewDropdown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    String text = '';
    if (widget.value != null) {
      dynamic option = widget.options.firstWhereOrNull((element) => element.id == widget.value?.id);
      text = getName(option);
    }

    if (text.isNotEmpty) {
      _controller.text = text;
    }
    super.didChangeDependencies();
  }

  String getName(StaffModel? option) {
    String text = '';
    if (option?.price != null && option!.price! > 0) {
      text += '${option.name} +${formatCurrency(context, price: option.price.toString())}';
    } else {
      text += option?.name ?? '';
    }
    return text;
  }

  @override
  void didUpdateWidget(covariant _ViewDropdown oldWidget) {
    if (widget.value != oldWidget.value) {
      String text = '';
      String textOld = '';

      if (widget.value != null) {
        dynamic option = widget.options.firstWhereOrNull((element) => element.id == widget.value?.id);
        text = getName(option);
      }

      if (oldWidget.value != null) {
        dynamic oldOption = oldWidget.options.firstWhereOrNull((element) => element.id == oldWidget.value?.id);
        textOld = getName(oldOption);
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

    TextStyle? titleStyle = theme.textTheme.titleSmall;
    TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);

    StaffModel? data = await showModalBottomSheet<StaffModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        MediaQueryData mediaQuery = MediaQuery.of(context);

        return Container(
          constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.5),
          child: buildViewModal(
            title: widget.titleSelect ?? AppLocalizations.of(context)!.translate('product_list_select'),
            child: Column(
              children: List.generate(widget.options.length, (index) {
                StaffModel option = widget.options[index];
                return CirillaTile(
                  title: Text(getName(option), style: option.id == widget.value?.id ? activeTitleStyle : titleStyle),
                  trailing: option.id == widget.value?.id
                      ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor)
                      : null,
                  isChevron: false,
                  onTap: () {
                    Navigator.pop(context, option);
                  },
                );
              }),
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
    );
    if (data != null && data != widget.value) {
      widget.onChange(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      onTap: () => showOption(context),
      decoration: const InputDecoration(suffixIcon: Icon(Icons.keyboard_arrow_down)),
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
