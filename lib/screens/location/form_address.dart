import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

List<String> _types = [
  'form_location_tag_home',
  'form_location_tag_office',
  'form_location_tag_other',
];

class FormAddressScreen extends StatefulWidget {
  static const routeName = '/location/form_address';

  final SettingStore? store;

  const FormAddressScreen({
    Key? key,
    this.store,
  }) : super(key: key);

  @override
  State<FormAddressScreen> createState() => _FormAddressScreenState();
}

class _FormAddressScreenState extends State<FormAddressScreen> with AppBarMixin {
  final TextEditingController _txtName = TextEditingController();
  int _visitType = 2;

  late AuthStore _authStore;
  bool _enableDefault = false;

  String _typeScreen = 'add';

  UserLocation _location = UserLocation(id: StringGenerate.uuid(), tag: '');
  UserLocation? _oldLocation;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    dynamic data = args != null ? args!['location'] : null;

    if (data is UserLocation) {
      String dataType = data.tag ?? '';
      _txtName.text = dataType;
      int visit = getTypeVisit(dataType);
      setState(() {
        _typeScreen = 'edit';
        _location = UserLocation.fromJson(data.toJson());
        _oldLocation = UserLocation.fromJson(data.toJson());
        _visitType = visit;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _txtName.addListener(() {
      String value = _txtName.text;
      int visit = getTypeVisit(value.trim().toLowerCase());
      setState(() {
        _visitType = visit;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _txtName.dispose();
    super.dispose();
  }

  Widget buildHeading(String title, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: paddingHorizontal.add(paddingVerticalMedium),
      color: theme.colorScheme.surface,
      child: Text(
        title,
        style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color),
      ),
    );
  }

  Widget buildAddress(ThemeData theme) {
    String text = _location.address is String && _location.address!.isNotEmpty ? _location.address! : 'Add address';
    Color? color = _location.address is String && _location.address!.isNotEmpty
        ? theme.textTheme.titleMedium?.color
        : theme.textTheme.labelSmall?.color;

    return CirillaTile(
      title: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(color: color),
      ),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectLocationScreen(
              store: widget.store,
              location: _location,
            ),
          ),
        );
        if (result != null && result['user_location'] is UserLocation) {
          setState(() {
            _location.address = result['user_location'].address;
            _location.lat = result['user_location'].lat;
            _location.lng = result['user_location'].lng;
          });
        }
      },
    );
  }

  Widget buildNameField(ThemeData theme, TranslateType translate) {
    InputBorder border = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.dividerColor),
    );
    return TextFormField(
      controller: _txtName,
      style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color),
      decoration: InputDecoration(
        hintText: translate('form_location_field_name'),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.labelSmall?.color),
        contentPadding: paddingVertical,
        border: border,
        enabledBorder: border,
        focusedErrorBorder: border,
        errorBorder: border,
        focusedBorder: border,
        disabledBorder: border,
      ),
    );
  }

  void saveData() async {
    UserLocation data = _location;
    data.tag = getTypeText(_visitType, _txtName.text);

    if (_typeScreen == 'add') {
      await _authStore.locationStore.saveLocation(
        location: data,
      );
    } else {
      await _authStore.locationStore.editLocation(
        location: _location,
      );
    }
    if (_enableDefault) {
      await _authStore.locationStore.setLocation(location: _location);
    }
    if (mounted) Navigator.pop(context);
  }

  bool checkSave() {
    if (_typeScreen == 'add') {
      if (_location.address is String && _location.lat is double && _location.lng is double) {
        return true;
      }
    }
    String textTag = getTypeText(_visitType, _txtName.text);
    if (_typeScreen == 'edit') {
      if (_oldLocation?.lat != _location.lat ||
          _oldLocation?.lng != _location.lng ||
          _oldLocation?.address != _location.address ||
          _oldLocation?.tag != textTag) {
        return true;
      }
      if (_enableDefault) {
        return true;
      }
    }
    return false;
  }

  int getTypeVisit(String value) {
    switch (value) {
      case 'home':
        return 0;
      case 'office':
        return 1;
      default:
        return 2;
    }
  }

  String getTypeText(int visit, String defaultText) {
    switch (visit) {
      case 0:
        return 'home';
      case 1:
        return 'office';
      default:
        return defaultText;
    }
  }

  void deleteLocation(TranslateType translate) async {
    if (_location.id is String) {
      String? result = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(translate('form_location_delete_dialog_title')),
            content: Text(translate('form_location_delete_dialog_content')),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: Text(translate('form_location_delete_dialog_cancel')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: Text(translate('form_location_delete_dialog_ok')),
              ),
            ],
          );
        },
      );
      if (result == "OK") {
        await _authStore.locationStore.deleteLocation(id: _location.id!);
        if (mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: _typeScreen == 'edit' ? translate('form_location_edit_txt') : translate('form_location_add_txt'),
        actions: _typeScreen == 'edit'
            ? [
                InkResponse(
                  onTap: () => deleteLocation(translate),
                  // onTap: () => onPressed(context),
                  radius: 29,
                  child: const Icon(
                    FeatherIcons.trash2,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 20),
              ]
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeading(translate('form_location_address'), theme),
                  Padding(
                    padding: paddingHorizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildAddress(theme),
                        CirillaTile(
                          title: Text(
                            translate('form_location_default_address'),
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color),
                          ),
                          trailing: CupertinoSwitch(
                            value: _enableDefault,
                            onChanged: (_) => setState(() {
                              _enableDefault = !_enableDefault;
                            }),
                          ),
                          isChevron: false,
                        ),
                        const SizedBox(height: 24),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...List.generate(_types.length, (index) {
                                return Padding(
                                  padding: const EdgeInsetsDirectional.only(end: itemPadding),
                                  child: ButtonSelect.filter(
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: itemPadding),
                                    isSelect: _visitType == index,
                                    colorSelect: theme.primaryColor,
                                    color: theme.colorScheme.surface,
                                    onTap: () {
                                      if (index != _visitType) {
                                        bool enableType = _location.tag != 'office' && _location.tag != 'home';
                                        String valueType = getTypeText(index, '${enableType ? _location.tag : ''}');
                                        _txtName.text = valueType;
                                      }
                                    },
                                    child: Text(
                                      translate(_types[index]),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: theme.textTheme.titleMedium?.color),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        if (_visitType > 1) buildNameField(theme, translate),
                        const SizedBox(height: itemPaddingLarge),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: paddingHorizontal.add(paddingVerticalLarge),
            decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, boxShadow: initBoxShadow),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: checkSave() ? saveData : null,
                style: ElevatedButton.styleFrom(
                  textStyle: theme.textTheme.titleSmall,
                ),
                child: Text(translate('form_location_button')),
              ),
            ),
          )
        ],
      ),
    );
  }
}
