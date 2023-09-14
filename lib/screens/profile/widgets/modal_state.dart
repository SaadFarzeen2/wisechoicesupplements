import 'package:cirilla/models/address/country_address.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';

class ModalState extends StatefulWidget {
  final String? stateId;
  final List? states;
  final Function(String? value)? onChange;

  const ModalState({
    Key? key,
    this.stateId,
    this.states,
    this.onChange,
  }) : super(key: key);

  @override
  State<ModalState> createState() => _ModalStateState();
}

class _ModalStateState extends State<ModalState> {
  final _txtSearch = TextEditingController();
  String search = '';
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Column(
      children: [
        Text(translate('address_select_state'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        TextFormField(
          controller: _txtSearch,
          onChanged: (value) {
            setState(() {
              search = value;
            });
          },
          decoration: InputDecoration(hintText: translate('address_search')),
        ),
        Expanded(
            child: ListView(
          children: widget.states!
              .where((element) => element['name'].toLowerCase().contains(search.toLowerCase()))
              .toList()
              .map((item) {
            TextStyle? titleStyle = theme.textTheme.titleSmall;
            TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);
            return CirillaTile(
              title: Text(item['name'], style: item['code'] == widget.stateId ? activeTitleStyle : titleStyle),
              trailing:
                  item['code'] == widget.stateId ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
              isChevron: false,
              onTap: () {
                widget.onChange!(item['code']);
              },
            );
          }).toList(),
        ))
      ],
    );
  }
}

class ModalStateStack extends StatefulWidget {
  final String? stateId;
  final List<CountryAddressData>? states;
  final Function(String? value)? onChange;

  const ModalStateStack({
    Key? key,
    this.stateId,
    this.states,
    this.onChange,
  }) : super(key: key);

  @override
  State<ModalStateStack> createState() => _ModalStateStack();
}

class _ModalStateStack extends State<ModalStateStack> {
  final _txtSearch = TextEditingController();
  String search = '';
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Column(
      children: [
        Text(translate('address_select_state'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        TextFormField(
          controller: _txtSearch,
          onChanged: (value) {
            setState(() {
              search = value;
            });
          },
          decoration: InputDecoration(hintText: translate('address_search')),
        ),
        Expanded(
          child: ListView(
            children: widget.states!
                .where((element) => element.name?.toLowerCase().contains(search.toLowerCase()) == true)
                .toList()
                .map((item) {
              TextStyle? titleStyle = theme.textTheme.titleSmall;
              TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);
              return CirillaTile(
                title: Text(item.name ?? '', style: item.code == widget.stateId ? activeTitleStyle : titleStyle),
                trailing:
                    item.code == widget.stateId ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
                isChevron: false,
                onTap: () {
                  widget.onChange!(item.code);
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
