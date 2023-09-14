import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

mixin TransactionWalletMixin {
  Widget buildName({TransactionWallet? data, required ThemeData theme}) {
    if (data?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 18,
          width: 200,
          color: Colors.white,
        ),
      );
    }
    return Text(data?.title ?? '', style: theme.textTheme.titleSmall);
  }

  Widget buildDate({TransactionWallet? data, required ThemeData theme, required TranslateType translate}) {
    if (data?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 11,
          width: 94,
          color: Colors.white,
        ),
      );
    }

    return Text(
      translate('wallet_date', {
        'date': formatDate(
          date: data?.date ?? '',
          dateFormat: 'MM/dd/yyyy hh:mm:a',
        )
      }),
      style: theme.textTheme.labelSmall?.copyWith(color: theme.textTheme.bodySmall?.color),
    );
  }

  Widget buildAmount(BuildContext context, {TransactionWallet? data, required ThemeData theme}) {
    if (data?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 18,
          width: 70,
          color: Colors.white,
        ),
      );
    }

    return Text(
      formatCurrency(context, price: '${data?.amount ?? '0'}', currency: data?.currency),
      style: theme.textTheme.titleSmall?.copyWith(color: theme.textTheme.labelSmall?.color),
    );
  }

  Widget buildType(BuildContext context,
      {TransactionWallet? data, required ThemeData theme, required TranslateType translate}) {
    if (data?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 24,
          width: 80,
          color: Colors.white,
        ),
      );
    }
    String type = data?.type ?? 'credit';

    String text = translate('wallet_credit');
    Color color = ColorBlock.leaf;
    IconData icon = FeatherIcons.plusCircle;

    if (type == 'debit') {
      text = translate('wallet_debit');
      color = ColorBlock.redLight;
      icon = FeatherIcons.minusCircle;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
