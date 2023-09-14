import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data.dart';
import 'reason_step.dart';
import 'term_step.dart';
import 'agree_step.dart';
import 'otp_step.dart';
import 'success_step.dart';

class DeleteAccountScreen extends StatefulWidget {
  static const String routeName = '/profile/delete_account';

  const DeleteAccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> with TickerProviderStateMixin, SnackMixin {
  late TabController _tabController;

  late SettingStore _settingStore;
  late AuthStore _authStore;

  bool _loadingSendOtp = false;
  bool _loading = false;

  String? _reason;
  bool _isAgree = false;

  bool _statusDelete = false;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void goStepStep(int value) {
    if (value >= 0 && value < _tabController.length) {
      _tabController.animateTo(value);
    }
  }

  void nextStep() {
    if (_tabController.index < _tabController.length - 1) {
      int newIndex = _tabController.index + 1;

      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _tabController.animateTo(newIndex);
      });
    }
  }

  void backStep() {
    if (_tabController.index > 0) {
      int newIndex = _tabController.index - 1;

      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _tabController.animateTo(newIndex);
      });
    }
  }

  void logout() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    _settingStore.removeTab();
  }

  void changeReason(String value) {
    setState(() {
      _reason = value;
    });
  }

  void changeAgree(bool value) {
    setState(() {
      _isAgree = value;
    });
  }

  void setSendOtpLoading(bool value) {
    setState(() {
      _loadingSendOtp = value;
    });
  }

  void setLoading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  void sendOtpDeleteAccount({Function? callback}) async {
    try {
      setSendOtpLoading(true);

      await _settingStore.requestHelper.sendOptDeleteAccount();
      setSendOtpLoading(false);
      callback?.call();
    } catch (e) {
      setSendOtpLoading(false);
      showError(context, e);
    }
  }

  void deleteAccount(String otp) async {
    try {
      setLoading(true);
      TranslateType translate = AppLocalizations.of(context)!.translate;
      Map<String, String>? item = reasonData.firstWhereOrNull((element) => get(element, ['value'], '') == _reason);

      Map<String, dynamic> data = await _settingStore.requestHelper.deleteAccount(
        data: {
          'reason': translate(get(item, ['label_name'], '')),
          'otp': otp,
        },
      );

      if (get(data, ['delete'], false)) {
        setLoading(false);
        setState(() {
          _statusDelete = true;
        });
        deleteSuccess();
      } else {
        setLoading(false);
        if (mounted) {
          showError(context, get(data, ['message'], ''));
        }
      }
    } catch (e) {
      setLoading(false);
      showError(context, e);
    }
  }

  void deleteSuccess() {
    _authStore.logout();
    nextStep();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_statusDelete) {
          logout();
        }
        return true;
      },
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ReasonStep(reason: _reason, changeReason: changeReason, nextStep: nextStep),
          TermStep(
            nextStep: () {
              changeAgree(false);
              nextStep();
            },
            backStep: backStep,
          ),
          AgreeStep(
            isAgree: _isAgree,
            changeAgree: changeAgree,
            nextStep: () => sendOtpDeleteAccount(callback: nextStep),
            backStep: backStep,
            loading: _loadingSendOtp,
          ),
          OtpStep(
            nextStep: deleteAccount,
            backStep: backStep,
            loading: _loading,
            resendOtp: sendOtpDeleteAccount,
            loadingResendOtp: _loadingSendOtp,
          ),
          SuccessStep(onComplete: logout),
        ],
      ),
    );
  }
}
