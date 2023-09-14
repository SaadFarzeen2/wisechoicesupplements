import 'package:cirilla/constants/color_block.dart';
import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  static const routeName = '/no_internet';

  const NoInternetPage({
    Key? key,
    this.suggestReopen = false,
  }) : super(key: key);

  final bool suggestReopen;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 90,
            width: 90,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1), spreadRadius: 5),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/global_refresh.png',
                width: 50,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Text(
            "No Internet Connection",
            style: theme.textTheme.bodyLarge?.copyWith(color: ColorBlock.redDark, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              suggestReopen
                  ? "We can't detect any internet connectivity. Please check your internet connection and reopen app."
                  : "We can't detect any internet connectivity. Please check your internet connection.",
              style: theme.textTheme.bodyMedium?.copyWith(color: ColorBlock.gray10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
