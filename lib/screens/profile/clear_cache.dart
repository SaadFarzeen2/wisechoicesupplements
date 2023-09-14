import 'dart:convert';

import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClearCache extends StatefulWidget {
  const ClearCache({Key? key}) : super(key: key);

  @override
  State<ClearCache> createState() => _ClearCacheState();
}

class _ClearCacheState extends State<ClearCache> {
  late SettingStore _settingStore;
  int _size = 0;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _getSize();
    super.didChangeDependencies();
  }

  void _getSize() {
    int size = 0;

    PersistHelper persistHelper = _settingStore.persistHelper;
    String? settings = persistHelper.getSettings();
    String? categories = persistHelper.getCategories();

    if (settings != null) {
      List<int> bytes = utf8.encode(settings);
      size += bytes.length;
    }

    if (categories != null) {
      List<int> bytes = utf8.encode(categories);
      size += bytes.length;
    }

    setState(() {
      _size = size;
    });
  }

  Future<void> _clearCache() async {
    PersistHelper persistHelper = _settingStore.persistHelper;
    await persistHelper.removeCategories();
    await persistHelper.removeSettings();
    _getSize();
  }

  _showAlertDialog(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(translate('clear_cache_cancel')),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget yesButton = TextButton(
      child: Text(translate('clear_cache_yes')),
      onPressed: () async {
        await _clearCache();
        if (mounted) Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(translate('clear_cache_heading')),
      content: Text(translate('clear_cache_description')),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return CirillaTile(
      title: Text(translate('clear_cache_heading'), style: theme.textTheme.titleSmall),
      trailing: Text(translate('clear_cache_bytes', {'size': '$_size'})),
      isChevron: true,
      onTap: () => _showAlertDialog(context),
    );
  }
}
