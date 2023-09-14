import 'dart:io';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product_review/product_review.dart';
import 'package:cirilla/store/product/review_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_captcha.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductReviewForm extends StatefulWidget {
  final Widget? product;
  final ProductReviewStore? store;
  final int? productId;

  const ProductReviewForm({
    Key? key,
    this.product,
    this.store,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductReviewForm> createState() => _ProductReviewFormState();
}

class _ProductReviewFormState extends State<ProductReviewForm> with SnackMixin, LoadingMixin, AppBarMixin {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  AuthStore? _authStore;
  SettingStore? _settingStore;

  final _formKey = GlobalKey<FormState>();

  final _txtReview = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  final List<XFile> _imageFileList = [];

  dynamic _pickImageError;

  bool enableAddVideo = true;

  TextEditingController _txtName = TextEditingController();
  TextEditingController _txtEmail = TextEditingController();

  FocusNode? _nameFocusNode;
  FocusNode? _emailFocusNode;

  int _rating = 5;

  bool _loading = false;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    _settingStore = Provider.of<SettingStore>(context);

    if (_authStore!.isLogin) {
      String name = _authStore?.user?.displayName ?? '';
      String email = _authStore?.user?.userEmail ?? '';

      _txtName = TextEditingController(text: name);
      _txtEmail = TextEditingController(text: email);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _txtReview.dispose();
    _txtName.dispose();
    _txtEmail.dispose();

    _nameFocusNode!.dispose();
    _emailFocusNode!.dispose();
    super.dispose();
  }

  Future<void> handleSubmit(String captcha, String phrase) async {
    setState(() {
      _loading = true;
    });
    List<MultipartFile> multipartImageList = [];

    for (var i = 0; i < _imageFileList.length; i++) {
      String file = _imageFileList.elementAt(i).path;
      var pic = await MultipartFile.fromFile(
        file,
        filename: file.split('/').last,
      );
      multipartImageList.add(pic);
    }

    try {
      ProductReview review = await widget.store!.writeReview(data: {
        "product_id": widget.productId,
        "review": _txtReview.text,
        "reviewer": _txtName.text,
        "reviewer_email": _txtEmail.text,
        "rating": _rating,
        "images[]": multipartImageList,
        "captcha": captcha,
        "phrase": phrase,
      });

      if (review.status == ProductReviewStatus.approved) {
        widget.store!.refresh();
      } else {
        if (mounted) showSuccess(context, 'Your review is awaiting approval');
      }

      setState(() {
        _loading = false;
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) showError(context, e);
    }
  }

  void _pickImage() async {
    final action = CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            try {
              final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 600);
              if (pickedFile != null) {
                setState(() {
                  _imageFileList.add(pickedFile);
                });
              }
            } catch (e) {
              setState(() {
                _pickImageError = e;
              });
            }
            if (mounted) Navigator.pop(context);
          },
          child: const Text("Take Photo"),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () async {
            try {
              final pickedFileList = await _picker.pickMultiImage(imageQuality: 50, maxWidth: 600);
              if (pickedFileList.isNotEmpty) {
                setState(() {
                  _imageFileList.addAll(pickedFileList);
                });
              }
            } catch (e) {
              setState(() {
                _pickImageError = e;
              });
            }
            if (mounted) Navigator.pop(context);
          },
          child: const Text("Photo Library"),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text("Cancel"),
        onPressed: () {
          if (mounted) Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Map<String, dynamic>? data = _settingStore?.data?.settings!['general']!.widgets!['general']!.fields;

    bool enableCaptchaReviewProduct = get(data, ['enableCaptchaReviewProduct'], true);

    return Scaffold(
      key: scaffoldMessengerKey,
      appBar: baseStyleAppBar(context, title: translate('product_reviews')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.product!,
            Padding(
              padding: paddingHorizontal.add(paddingVerticalLarge),
              child: Column(
                children: [
                  Text(translate('product_tab_star')),
                  const SizedBox(height: 16),
                  CirillaRating.select(
                    defaultRating: _rating,
                    onFinishRating: (int value) => setState(() {
                      _rating = value;
                    }),
                  ),
                  const SizedBox(height: 48),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildReviewField(translate),
                        if (!_authStore!.isLogin) ...[
                          const SizedBox(height: 16),
                          buildNameField(translate),
                          const SizedBox(height: 16),
                          buildEmailField(translate),
                        ],
                        SizedBox(height: _imageFileList.isNotEmpty ? itemPadding : itemPaddingLarge),
                        buildPreviewImages(),
                        buildPhotos(),
                        const SizedBox(height: itemPaddingLarge),
                        CirillaCaptchaWrap(
                          enable: enableCaptchaReviewProduct,
                          submit: handleSubmit,
                          buildButton: (onPressed) {
                            return SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!_loading && _formKey.currentState!.validate()) {
                                    onPressed();
                                  }
                                },
                                child: _loading
                                    ? entryLoading(
                                        context,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      )
                                    : Text(translate('product_submit_review')),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildReviewField(TranslateType translate) {
    return TextFormField(
      controller: _txtReview,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_review_required');
        }
        return null;
      },
      maxLines: 5,
      decoration: InputDecoration(
        labelText: translate('input_review'),
        alignLabelWithHint: true,
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      },
    );
  }

  Widget buildNameField(TranslateType translate) {
    return TextFormField(
      controller: _txtName,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_name_required');
        }
        return null;
      },
      decoration: InputDecoration(labelText: translate('input_name')),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_emailFocusNode);
      },
    );
  }

  Widget buildEmailField(TranslateType translate) {
    return TextFormField(
      controller: _txtEmail,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_email_required');
        }
        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
          return translate('validate_email_value');
        }
        return null;
      },
      decoration: InputDecoration(labelText: translate('input_email')),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget buildPreviewImages() {
    if (_imageFileList.isNotEmpty) {
      return SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.start,
          children: List.generate(_imageFileList.length, (index) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsetsDirectional.only(
                    end: itemPaddingMedium,
                    bottom: itemPaddingMedium,
                    top: itemPaddingMedium,
                  ),
                  child: Image.file(
                    File(_imageFileList[index].path),
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: MediaQuery.of(context).size.width * 0.18,
                    fit: BoxFit.cover,
                  ),
                ),
                InkResponse(
                  radius: 0,
                  onTap: () {
                    setState(() {
                      _imageFileList.replaceRange(index, index + 1, []);
                    });
                  },
                  child: Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(left: 55, top: 5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Icon(
                      FeatherIcons.x,
                      size: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall,
      );
    } else {
      return Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall,
      );
    }
  }

  Widget buildPhotos() {
    return Row(
      children: [
        buildSelectButton(
          onTap: () {
            _pickImage();
          },
          icon: Icon(FeatherIcons.camera, color: Theme.of(context).primaryColor),
          title: 'Add Image',
        ),
        if (!enableAddVideo) ...[
          const SizedBox(
            width: 16,
          ),
          buildSelectButton(
            icon: Icon(FeatherIcons.video, color: Theme.of(context).primaryColor),
            title: 'Add Video',
          ),
        ]
      ],
    );
  }

  Widget buildSelectButton({GestureTapCallback? onTap, Widget? icon, String? title}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: DottedBorder(
          color: Theme.of(context).primaryColor,
          strokeWidth: 1,
          dashPattern: const [6, 3],
          borderType: BorderType.RRect,
          radius: const Radius.circular(4),
          child: SizedBox(
            height: 44,
            child: Center(
              child: Column(
                children: [
                  icon ?? Container(),
                  Text(
                    title ?? '',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
