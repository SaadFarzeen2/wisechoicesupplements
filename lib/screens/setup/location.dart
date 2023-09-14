import 'package:cirilla/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';

class LocationSetupScreen extends StatelessWidget {
  const LocationSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: paddingExtraLarge,
          child: Column(
            children: [
              Text(
                'Looking for your location...',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Icon(
                FontAwesomeIcons.mapMarked,
                size: 94,
                color: theme.primaryColor,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(height: 60),
                  Positioned(
                    top: 24,
                    left: 0,
                    right: 0,
                    child: Text(
                      '396 NY-52, Woodbourne, NY 12788',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
