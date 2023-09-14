// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionWallet _$TransactionWalletFromJson(Map<String, dynamic> json) => TransactionWallet(
      id: json['transaction_id'] as String?,
      title: json['details'] as String?,
      type: json['type'] as String?,
      amount: TransactionWallet._amountFromJson(json['amount']),
      date: json['date'] as String?,
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$TransactionWalletToJson(TransactionWallet instance) => <String, dynamic>{
      'transaction_id': instance.id,
      'details': instance.title,
      'type': instance.type,
      'amount': instance.amount,
      'date': instance.date,
      'currency': instance.currency,
    };
