// Flutter libraries
import 'package:flutter/material.dart';

// Themes

// Packages and dependencies or helper functions
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:cirilla/config_app.dart';
import 'package:cirilla/constants/color_block.dart';

// View
import 'package:cirilla/screens/no_internet/no_internet_page.dart';
import 'package:cirilla/screens/no_internet/widgets/internet_connection_dialog.dart';

abstract class NoInternetMixin {
  /// Banner
  void showNotInternetConnectedBanner(
    BuildContext context, {
    bool suggestReopen = false,
  }) {
    final noInternetBanner = MaterialBanner(
      content: Text(
        suggestReopen
            ? "Can't connect to the internet, you may be offline. Please check your internet connection and reopen app."
            : "Can't connect to the internet, you may be offline.",
        style: const TextStyle(
          color: ColorBlock.white,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: ColorBlock.red,
      actions: const [
        SizedBox.shrink(),
      ],
    );
    ScaffoldMessenger.of(context).showMaterialBanner(noInternetBanner);
  }

  void hideNotInternetConnectedBanner(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  ///SnackBar
  void showInternetConnectedSnack(BuildContext context) {
    const snackBar = SnackBar(
      duration: Duration(milliseconds: 700),
      content: Text(
        'Internet connected !',
        style: TextStyle(
          color: ColorBlock.white,
        ),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void checkAndSubscribeConnection({
    required BuildContext context,
    StreamSubscription<ConnectivityResult>? subscription,
    Timer? checkConnectionTimer,
    Timer? autoCLoseTimer,
  }) async {
    String type = internetNotificationType;
    ValueNotifier<bool> internetConnected = ValueNotifier<bool>(true);
    bool showInternetConnected = false;
    bool internetDialogShowing = false;

    /// Check internet when open app___________________
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        internetConnected.value = false;
        switch (type) {
          case 'per-page':
            Navigator.pushNamed(context, NoInternetPage.routeName);
            break;
          case 'banner':
            showNotInternetConnectedBanner(
              context,
              suggestReopen: true,
            );
            break;
          default:
            if (!internetDialogShowing) {
              if (checkConnectionTimer?.isActive ?? false) {
                checkConnectionTimer?.cancel();
              }
              // Set timer to recheck connection.
              checkConnectionTimer = Timer(const Duration(seconds: 2), () {
                // Recheck connection
                Connectivity().checkConnectivity().then((value) {
                  if (value == ConnectivityResult.none) {
                    internetDialogShowing = true;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return InternetConnectionDialog(
                          suggestReopen: true,
                          onTap: () {
                            internetDialogShowing = false;
                            Navigator.of(context).pop();
                          },
                          internetConnected: internetConnected,
                        );
                      },
                      barrierDismissible: false,
                    );
                  }
                });
              });
            }
            break;
        }
      }
    });

    /// Finish check internet when open app____________

    /// Subscribe connect-listener__________________________________
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      /// Handle when internet disconnected________
      if (result == ConnectivityResult.none) {
        // When internet disconnected
        debugPrint("Internet disconnected");
        switch (type) {
          case 'per-page':
            Navigator.pushNamed(context, NoInternetPage.routeName);
            break;
          case 'banner':
            showNotInternetConnectedBanner(context);
            break;
          default:
          // Cancel previous timer
            if (checkConnectionTimer?.isActive ?? false) {
              checkConnectionTimer?.cancel();
            }
            if (!internetDialogShowing) {
              // Set timer to recheck connection.
              checkConnectionTimer = Timer(const Duration(seconds: 2), () {
                // Recheck connection
                Connectivity().checkConnectivity().then((value) {
                  if (value == ConnectivityResult.none) {
                    internetConnected.value = false;
                    internetDialogShowing = true;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return InternetConnectionDialog(
                          onTap: () {
                            internetDialogShowing = false;
                            Navigator.of(context).pop();
                          },
                          internetConnected: internetConnected,
                        );
                      },
                      barrierDismissible: false,
                    );
                  }
                });
              });
            } else {
              checkConnectionTimer = Timer(const Duration(seconds: 2), () {
                // Recheck connection
                Connectivity().checkConnectivity().then((value) {
                  if (value == ConnectivityResult.none) {
                    internetConnected.value = false;
                  }
                });
              });
            }
            break;
        }
      }

      /// Finish handle when internet disconnected_

      /// Handle when internet connected_________
      else if (result != ConnectivityResult.bluetooth) {
        debugPrint("Internet connected");
        switch (type) {
          case 'per-page':
            if (showInternetConnected) {
              showInternetConnectedSnack(context);
              showInternetConnected = false;
            }
            break;
          case 'banner':
            if (showInternetConnected) {
              showInternetConnectedSnack(context);
              showInternetConnected = false;
            }
            hideNotInternetConnectedBanner(context);
            break;
          default:
            if (!internetConnected.value) {
              // Cancel previous timer
              if (checkConnectionTimer?.isActive ?? false) {
                checkConnectionTimer?.cancel();
              }
              if (!internetDialogShowing) {
                // Set timer to recheck connection.
                checkConnectionTimer = Timer(const Duration(seconds: 2), () {
                  // Recheck connection.
                  Connectivity().checkConnectivity().then(
                        (value) {
                      if (value != ConnectivityResult.bluetooth && value != ConnectivityResult.none) {
                        internetConnected.value = true;
                        internetDialogShowing = true;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return InternetConnectionDialog(
                              onTap: () {
                                internetDialogShowing = false;
                                Navigator.of(context).pop();
                              },
                              internetConnected: internetConnected,
                            );
                          },
                          barrierDismissible: false,
                        );
                      }
                    },
                  );
                });
              } else {
                checkConnectionTimer = Timer(const Duration(seconds: 2), () {
                  // Recheck connection.
                  Connectivity().checkConnectivity().then(
                        (value) {
                      if (value != ConnectivityResult.bluetooth && value != ConnectivityResult.none) {
                        internetConnected.value = true;
                      }
                    },
                  );
                });
              }
            }
            break;
        }
      }

      /// Finish handle when internet connected__
    });

    /// Finish subscribe connect-listener____________________________
  }


}
