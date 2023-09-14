import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';

class AccountScreen extends StatelessWidget with AppBarMixin {
  static const String routeName = '/profile/account';

  final SettingStore? store;

  const AccountScreen({
    Key? key,
    this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    WidgetConfig? widgetConfig = store?.data?.screens?['profile']?.widgets?['profilePage']!;
    Map<String, dynamic>? fields = widgetConfig?.fields;

    bool enableAddressBook = get(fields, ['enableAddressBook'], false);

    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('edit_account_your_account')),
      body: SingleChildScrollView(
        padding: paddingHorizontal,
        child: Column(
          children: [
            CirillaTile(
              title: Text(translate('edit_account'), style: theme.textTheme.titleSmall),
              onTap: () => Navigator.of(context).pushNamed(EditAccountScreen.routeName),
            ),
            // CirillaTile(
            //   title: Text(translate('change_phone'), style: theme.textTheme.titleSmall),
            //   onTap: () {},
            // ),
            CirillaTile(
              title: Text(translate('change_password'), style: theme.textTheme.titleSmall),
              onTap: () => Navigator.of(context).pushNamed(ChangePasswordScreen.routeName),
            ),
            if (enableAddressBook)
              CirillaTile(
                title: Text(translate('address_book_txt'), style: theme.textTheme.titleSmall),
                onTap: () => Navigator.of(context).pushNamed(AddressBookScreen.routeName),
              )
            else ...[
              CirillaTile(
                title: Text(translate('address_billing'), style: theme.textTheme.titleSmall),
                onTap: () => Navigator.of(context).pushNamed(AddressBillingScreen.routeName),
              ),
              CirillaTile(
                title: Text(translate('address_shipping'), style: theme.textTheme.titleSmall),
                onTap: () => Navigator.of(context).pushNamed(AddressShippingScreen.routeName),
              ),
            ],
            CirillaTile(
              title: Text(translate('delete_account_txt'), style: theme.textTheme.titleSmall),
              onTap: () => Navigator.of(context).pushNamed(DeleteAccountScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
