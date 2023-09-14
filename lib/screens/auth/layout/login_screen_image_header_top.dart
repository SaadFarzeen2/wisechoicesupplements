import 'package:cirilla/constants/constants.dart';
import 'package:flutter/material.dart';

class LoginScreenImageHeaderTop extends StatelessWidget {
  final Widget? header;
  final Widget? loginForm;
  final Widget? socialLogin;
  final Widget? registerText;
  final Widget? termText;
  final Widget? title;
  final Color? background;
  final EdgeInsetsDirectional? padding;
  final EdgeInsetsDirectional? paddingFooter;

  const LoginScreenImageHeaderTop({
    Key? key,
    this.header,
    this.loginForm,
    this.socialLogin,
    this.registerText,
    this.termText,
    this.title,
    this.background,
    this.padding,
    this.paddingFooter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double heightHeader = height * 0.3;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: heightHeader,
          automaticallyImplyLeading: false,
          primary: false,
          backgroundColor: background,
          flexibleSpace: Stack(
            children: [
              SizedBox(
                height: heightHeader,
                width: width,
                child: header,
              ),
              Positioned(
                bottom: -1,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  width: width,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: borderRadiusBottomSheetLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: padding!,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    title!,
                    const SizedBox(height: 24),
                    loginForm!,
                    if (registerText != null) ...[
                      const SizedBox(height: 32),
                      registerText!,
                    ],
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: true,
          child: Container(
            padding: paddingFooter,
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                socialLogin!,
                const SizedBox(height: 16),
                termText!,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
