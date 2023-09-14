import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class LanguageSetupScreen extends StatefulWidget {
  final SettingStore? store;

  const LanguageSetupScreen({
    Key? key,
    this.store,
  }) : super(key: key);

  @override
  State<LanguageSetupScreen> createState() => _LanguageSetupScreenState();
}

class _LanguageSetupScreenState extends State<LanguageSetupScreen> {
  late String _language;

  @override
  void initState() {
    _language = widget.store?.locale ?? defaultLanguage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductCategoryStore productCategoryStore = Provider.of<ProductCategoryStore>(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    List<Language> languages = widget.store?.supportedLanguages ?? [];

    return Theme(
      data: theme.copyWith(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 48,
          margin: paddingHorizontal.add(paddingVerticalMedium),
          child: ElevatedButton(
            onPressed: () {
              productCategoryStore.onChanged(language: _language);
              widget.store?.closeSelectLanguage();
            },
            child: Text(translate('edit_account_save')),
          ),
        ),
        body: Observer(
          builder: (_) => Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: layoutPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.only(end: 25),
                    child: Icon(
                      FontAwesomeIcons.language,
                      size: 76,
                      color: theme.primaryColor,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(translate('select_language'), style: theme.textTheme.titleMedium),
                  if (languages.isNotEmpty) ...[
                    const SizedBox(height: 26),
                    Container(
                      padding: paddingHorizontal,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(itemPaddingMedium),
                        boxShadow: initBoxShadow,
                      ),
                      child: Column(
                        children: List.generate(languages.length, (index) {
                          Language lang = languages[index];
                          bool isSelected = lang.locale == _language;
                          return CirillaTile(
                            title: Text(
                              lang.language!,
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(color: isSelected ? theme.primaryColor : theme.textTheme.bodySmall?.color),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    FeatherIcons.check,
                                    size: 16,
                                    color: theme.primaryColor,
                                  )
                                : null,
                            isChevron: false,
                            isDivider: index < languages.length - 1,
                            onTap: () {
                              if (!isSelected) {
                                widget.store?.changeLanguage(lang.locale!);
                                setState(() {
                                  _language = lang.locale!;
                                });
                              }
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
