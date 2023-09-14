import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/auth/forgot_screen.dart';
import 'package:cirilla/screens/auth/register_screen.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:html/dom.dart' as dom;

///
import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

///
import 'layout/login_screen_logo_top.dart';
import 'layout/login_screen_social_top.dart';
import 'layout/login_screen_image_header_top.dart';
import 'layout/login_screen_header_conner.dart';

///
import 'widgets/login_form.dart';
import 'widgets/social_login.dart';
import 'widgets/heading_text.dart';
import 'widgets/term_text.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  final SettingStore? store;

  const LoginScreen({Key? key, this.store}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AppBarMixin, LoadingMixin, SnackMixin, Utility, GeneralMixin {
  AuthStore? _authStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore ??= Provider.of<AuthStore>(context);
  }

  void _onLinkTab(
    String? url,
    RenderContext renderContext,
    Map<String, String> attributes,
    dom.Element? element,
  ) {
    if (url!.isNotEmpty && url.contains("lost-password")) {
      Navigator.pushNamed(context, ForgotScreen.routeName);
    }
  }

  void _handleLogin(Map<String, dynamic> queryParameters) async {
    try {
      ModalRoute? modalRoute = ModalRoute.of(context);
      await _authStore!.loginStore.login(queryParameters);
      final Map<String, dynamic> args = modalRoute!.settings.arguments as Map<String, dynamic>;
      ShowMessageType? showMessage = args['showMessage'];
      if (showMessage != null) {
        showMessage(message: 'Logged!');
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      showError(context, e, onLinkTap: _onLinkTab);
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(builder: (_) {
      // Login screen config
      WidgetConfig widgetConfig = widget.store!.data!.screens!['login']!.widgets!['login']!;

      // Get configs
      Map<String, dynamic>? configsLogin = widget.store!.data!.screens!['login']!.configs;
      Color appbarColor =
          ConvertData.fromRGBA(get(configsLogin, ['appbarColor', widget.store!.themeModeKey]), Colors.white);
      bool extendBodyBehindAppBar = get(configsLogin, ['extendBodyBehindAppBar'], false);

      // Get fields
      Map<String, dynamic> fields = widgetConfig.fields ?? {};
      bool titleAppBar = get(fields, ['titleAppBar'], false);

      // Get styles
      Map<String, dynamic>? stylesLogin = widgetConfig.styles;
      Color background =
          ConvertData.fromRGBA(get(stylesLogin, ['background', widget.store!.themeModeKey]), Colors.white);

      // Layout
      String layout = widgetConfig.layout ?? Strings.loginLayoutSocialTop;

      bool enableRegister = widget.store != null ? getConfig(widget.store!, ['enableRegister'], true) : true;

      return Scaffold(
        backgroundColor: background,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        appBar: AppBar(
          backgroundColor: appbarColor,
          title: titleAppBar ? Text(translate('login_txt_login')) : null,
          elevation: 0,
          centerTitle: true,
          leading: leading(),
        ),
        body: Stack(
          children: [
            buildLayout(layout, widgetConfig, background, enableRegister, translate),
            if (_authStore!.loginStore.loading)
              Align(
                alignment: FractionalOffset.center,
                child: buildLoadingOverlay(context),
              ),
          ],
        ),
      );
    });
  }

  Widget buildLayout(
    String layout,
    WidgetConfig widgetConfig,
    Color background,
    bool enableRegister,
    TranslateType translate,
  ) {
    String? headerImage = get(widgetConfig.styles, ['headerImage', 'src'], Assets.noImageUrl);
    EdgeInsetsDirectional padding = ConvertData.space(get(widgetConfig.styles, ['padding']));

    bool? loginFacebook = get(widgetConfig.fields, ['loginFacebook'], true);
    bool? loginGoogle = get(widgetConfig.fields, ['loginGoogle'], true);
    bool? loginApple = get(widgetConfig.fields, ['loginApple'], true);
    bool? loginPhoneNumber = get(widgetConfig.fields, ['loginPhoneNumber'], true);

    String? term = get(widgetConfig.fields, ['term', widget.store!.languageKey], '');

    Map<String, bool?> enable = {
      'facebook': loginFacebook,
      'google': loginGoogle,
      'sms': loginPhoneNumber,
      'apple': loginApple,
    };

    Widget social = SocialLogin(
      store: _authStore!.loginStore,
      handleLogin: _handleLogin,
      enable: enable,
      type: 'login',
    );

    Widget? register = enableRegister ? const _TextRegister() : null;

    switch (layout) {
      case Strings.loginLayoutLogoTop:
        return LoginScreenLogoTop(
          header: headerImage != "" ? Image.network(headerImage!, height: 48) : Container(),
          loginForm: LoginForm(handleLogin: _handleLogin),
          socialLogin: social,
          registerText: register,
          termText: TermText(html: term),
          padding: padding,
          paddingFooter: const EdgeInsetsDirectional.only(top: 24, bottom: 24, start: 20, end: 20),
          background: background,
        );
      case Strings.loginLayoutImageHeaderTop:
        return LoginScreenImageHeaderTop(
          header: headerImage != ""
              ? Positioned.fill(
                  child: Image.network(
                    headerImage!,
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fitWidth,
                  ),
                )
              : Container(),
          title: HeadingText(title: translate('login_txt_login_now')),
          loginForm: LoginForm(handleLogin: _handleLogin),
          socialLogin: social,
          registerText: register,
          termText: TermText(html: term),
          background: background,
          padding: padding,
          paddingFooter: const EdgeInsetsDirectional.only(top: 24, bottom: 24, start: 20, end: 20),
        );
      case Strings.loginLayoutImageHeaderCorner:
        return LoginScreenImageHeaderConner(
          header: headerImage != ""
              ? Image.network(
                  headerImage!,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                )
              : Container(),
          title: HeadingText(title: translate('login_txt_login_now')),
          loginForm: LoginForm(handleLogin: _handleLogin),
          socialLogin: social,
          registerText: register,
          termText: TermText(html: term),
          padding: padding,
          paddingFooter: const EdgeInsetsDirectional.only(top: 24, bottom: 24, start: 20, end: 20),
          background: background,
        );
      default:
        return LoginScreenSocialTop(
          padding: padding,
          paddingFooter: const EdgeInsetsDirectional.only(top: 24, bottom: 24, start: 20, end: 20),
          header: HeadingText.animated(title: translate('login_txt_login'), enable: enable),
          loginForm: LoginForm(handleLogin: _handleLogin),
          socialLogin: SocialLogin(
            store: _authStore!.loginStore,
            handleLogin: _handleLogin,
            mainAxisAlignment: MainAxisAlignment.start,
            enable: enable,
            type: 'login',
          ),
          termText: TermText(mainAxisAlignment: MainAxisAlignment.start, html: term),
          registerText: register,
        );
    }
  }
}

class _TextRegister extends StatelessWidget {
  const _TextRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(translate('login_description_register'), style: textTheme.bodySmall),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed(RegisterScreen.routeName),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: textTheme.bodySmall,
          ),
          child: Text(translate('login_txt_register_now')),
        )
      ],
    );
  }
}
