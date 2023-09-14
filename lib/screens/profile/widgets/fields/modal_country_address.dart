import 'package:cirilla/models/address/country_address.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';

class ModalCountryAddress extends StatefulWidget with Utility {
  final String? value;
  final List<CountryAddressData> data;
  final Function(String? value)? onChange;
  final String title;
  final String titleSearch;

  const ModalCountryAddress({
    Key? key,
    this.value,
    this.data = const [],
    this.onChange,
    this.title = 'Title',
    this.titleSearch = 'Search',
  }) : super(key: key);
  @override
  State<ModalCountryAddress> createState() => _ModalCountryAddressState();
}

class _ModalCountryAddressState extends State<ModalCountryAddress> {
  final _txtSearch = TextEditingController();
  String search = '';

  @override
  void dispose() {
    _txtSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        TextFormField(
          controller: _txtSearch,
          onChanged: (value) {
            setState(() {
              search = value;
            });
          },
          decoration: InputDecoration(hintText: widget.titleSearch),
        ),
        Expanded(
          child: ListView(
            children: widget.data
                .where((element) => element.name!.toLowerCase().contains(search.toLowerCase()))
                .toList()
                .map((item) {
              TextStyle? titleStyle = theme.textTheme.titleSmall;
              TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);
              return CirillaTile(
                title: Text(item.name!, style: item.code == widget.value ? activeTitleStyle : titleStyle),
                trailing:
                    item.code == widget.value ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
                isChevron: false,
                onTap: () {
                  String? value = item.code != widget.value ? item.code : null;
                  widget.onChange?.call(value);
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
