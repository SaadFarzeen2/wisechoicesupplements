import 'package:cirilla/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_wallet.g.dart';

@JsonSerializable()
class TransactionWallet {
  @JsonKey(name: 'transaction_id')
  String? id;

  @JsonKey(name: 'details')
  String? title;

  String? type;

  @JsonKey(fromJson: _amountFromJson)
  double? amount;

  String? date;

  String? currency;

  TransactionWallet({
    this.id,
    this.title,
    this.type,
    this.amount,
    this.date,
    this.currency,
  });

  static double? _amountFromJson(dynamic value) => ConvertData.stringToDouble(value);

  factory TransactionWallet.fromJson(Map<String, dynamic> json) => _$TransactionWalletFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionWalletToJson(this);
}
