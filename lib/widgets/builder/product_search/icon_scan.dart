import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class IconScan extends StatefulWidget {
  final Color? color;

  const IconScan({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  State<IconScan> createState() => _IconScanState();
}

class _IconScanState extends State<IconScan> {
  late SettingStore _settingStore;
  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    super.didChangeDependencies();
  }

  void onPressedScannerIcon(BuildContext context) async {
    String option = await _getOptionScanner(context);
    if (option.isNotEmpty) {
      await _scanBarcodeNormal(scanMode: (option == "qrcode") ? ScanMode.QR : ScanMode.BARCODE).then((value) async {
        if (value.isNotEmpty && value != '-1') {
          await _getIdProductWithBarcode(barcode: value).then((product) {
            if (product != null) {
              Navigator.pushNamed(context, '${ProductScreen.routeName}/${product.id}', arguments: {"product": product});
            }
          });
        }
      });
    }
  }

  Future<String> _scanBarcodeNormal({ScanMode? scanMode}) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, scanMode ?? ScanMode.DEFAULT);
    } catch (_) {
      barcodeScanRes = '';
    }
    return barcodeScanRes;
  }

  Future<String> _getOptionScanner(BuildContext context) async {
    if (FocusScope.of(context).hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    String option = "";
    final action = CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            option = "barcode";
            Navigator.pop(context);
          },
          child: const Text("Barcode"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            option = "qrcode";
            Navigator.pop(context);
          },
          child: const Text("QR Code"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    await showCupertinoModalPopup(context: context, builder: (context) => action);
    return option;
  }

  Future<Product?> _getIdProductWithBarcode({required String barcode}) async {
    Product? product;
    List<Product>? list = await _settingStore.requestHelper.getProducts(queryParameters: {
      "barcode": barcode,
      "app-builder-decode": true,
    });
    if (list != null) {
      if (list.isNotEmpty) {
        product = list.first;
      }
    }
    return product;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !isWeb ? () => onPressedScannerIcon(context) : null,
      child: Icon(
        Icons.qr_code_scanner_outlined,
        size: 25,
        color: widget.color,
      ),
    );
  }
}
