import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/models/product/product_type.dart';
import 'package:cirilla/store/product/variation_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woo_booking/product_booking.dart';

import 'product_appointment/product_appointment.dart';
import 'product_variable.dart';
import 'product_grouped.dart';

class ProductTypeWidget extends StatelessWidget {
  final Product? product;
  final VariationStore? store;
  final String? align;

  final Map<int?, int>? qty;
  final Map<String, dynamic>? appointment;
  final Function? onChangedGrouped;
  final Function(Map<String, dynamic>)? onChangedAppointment;

  const ProductTypeWidget({
    Key? key,
    this.product,
    this.store,
    this.align,
    this.qty,
    this.appointment,
    this.onChangedGrouped,
    this.onChangedAppointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (product!.type == productTypeVariable) {
      return ProductVariable(
        product: product,
        store: store,
        alignTitle: ConvertData.toTextAlignDirection(align),
      );
    }

    if (product!.type == productTypeGrouped) {
      return ProductTypeGrouped(
        product: product,
        qty: qty,
        onChanged: onChangedGrouped,
      );
    }

    if (product!.type == productTypeAppointment) {
      return ProductAppointment(
        appointment: appointment,
        onChanged: onChangedAppointment,
        productId: product!.id.toString(),
      );
    }

    if (product!.type == productTypeBooking) {
      return ProductWooBooking(
        appointment: appointment,
        onChanged: onChangedAppointment,
        productId: product!.id.toString(),
        getSlots: Provider.of<SettingStore>(context).requestHelper.getActiveHours,
        getBookingProduct: Provider.of<SettingStore>(context).requestHelper.getAppointmentProduct,
        getBookableDays: Provider.of<SettingStore>(context).requestHelper.getBookableDays,
      );
    }

    return Container();
  }
}
