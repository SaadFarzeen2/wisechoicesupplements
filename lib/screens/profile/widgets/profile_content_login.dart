import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/auth/user.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/types/types.dart';
import 'package:ui/ui.dart';
import 'package:cirilla/utils/url_launcher.dart';

import 'profile_content.dart';
import 'text_wallet.dart';

class ProfileContentLogin extends ProfileContent {
  final User? user;
  final Function? logout;
  final bool enableWallet;
  final bool enableDownload;
  final bool enableChat;

  const ProfileContentLogin({
    Key? key,
    String? phone,
    Widget? footer,
    bool? enablePhone,
    bool? enableHelpInfo,
    this.enableWallet = false,
    this.enableDownload = true,
    this.user,
    this.logout,
    this.enableChat = false,
  }) : super(
          key: key,
          phone: phone,
          footer: footer,
          enablePhone: enablePhone,
          enableHelpInfo: enableHelpInfo,
        );

  @override
  Widget buildLayout(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Column(
      children: [
        UserContainedItem(
          image: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CirillaCacheImage(
              user?.socialAvatar?.isNotEmpty == true ? user!.socialAvatar : user?.avatar ?? '',
              width: 60,
              height: 60,
            ),
          ),
          title: Text(user!.displayName ?? "Admin",
              style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          leading: Text(translate('welcome'), style: theme.textTheme.bodySmall),
          padding: paddingHorizontalLarge.add(paddingVerticalMedium),
          color: theme.colorScheme.surface,
          onClick: () => Navigator.of(context).pushNamed(AccountScreen.routeName),
        ),
        const SizedBox(height: 40),
        buildInfo(
          context,
          title: translate('information'),
          child: Column(
            children: [
              CirillaTile(
                title: Text(translate('edit_account_my_account'), style: theme.textTheme.titleSmall),
                leading: const Icon(
                  FeatherIcons.user,
                  size: 16,
                ),
                onTap: () => Navigator.of(context).pushNamed(AccountScreen.routeName),
              ),
              CirillaTile(
                title: Text(translate('order_return'), style: theme.textTheme.titleSmall),
                leading: const Icon(
                  FeatherIcons.package,
                  size: 16,
                ),
                onTap: () => Navigator.of(context).pushNamed(OrderListScreen.routeName),
              ),
              if (enableWallet)
                CirillaTile(
                  title: Text(translate('profile_wallet_txt'), style: theme.textTheme.titleSmall),
                  leading: const Icon(
                    FeatherIcons.creditCard,
                    size: 16,
                  ),
                  trailing: const TextWallet(),
                  onTap: () => Navigator.of(context).pushNamed(WalletScreen.routeName),
                ),
              if (enableDownload)
                CirillaTile(
                  title: Text(translate('download_title'), style: theme.textTheme.titleSmall),
                  leading: const Icon(
                    FeatherIcons.download,
                    size: 16,
                  ),
                  onTap: () => Navigator.of(context).pushNamed(DownloadScreen.routeName),
                ),
              if (enableChat)
                CirillaTile(
                  title: Text(translate('chat'), style: theme.textTheme.titleSmall),
                  leading: const Icon(
                    FeatherIcons.messageCircle,
                    size: 16,
                  ),
                  onTap: () => Navigator.of(context).pushNamed(ChatListScreen.routeName),
                ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        buildInfo(
          context,
          title: translate('settings'),
          child: Column(
            children: [
              CirillaTile(
                title: Text(translate('app_settings'), style: theme.textTheme.titleSmall),
                leading: const Icon(
                  FeatherIcons.settings,
                  size: 16,
                ),
                onTap: () => Navigator.of(context).pushNamed(SettingScreen.routeName),
              ),
              if (enableHelpInfo == true)
                CirillaTile(
                  title: Text(translate('help_info'), style: theme.textTheme.titleSmall),
                  leading: const Icon(
                    FeatherIcons.info,
                    size: 16,
                  ),
                  onTap: () => Navigator.of(context).pushNamed(HelpInfoScreen.routeName),
                ),
              if (enablePhone!)
                CirillaTile(
                  title: Text(translate('hotline'), style: theme.textTheme.titleSmall),
                  leading: const Icon(
                    FeatherIcons.phoneForwarded,
                    size: 16,
                  ),
                  trailing: Text(phone!, style: theme.textTheme.bodyLarge),
                  onTap: () => launch("tel://$phone"),
                ),
              CirillaTile(
                title: Text(translate('sign_out'), style: theme.textTheme.titleSmall),
                leading: const Icon(
                  FeatherIcons.logOut,
                  size: 16,
                ),
                onTap: logout as void Function()?,
                isChevron: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
