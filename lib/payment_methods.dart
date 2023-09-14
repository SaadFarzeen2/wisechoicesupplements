import 'package:cirilla/screens/checkout/gateway/gateway.dart';
import 'package:payment_base/payment_base.dart';

final Map<String, PaymentBase> methods = {
  ChequeGateway.key: ChequeGateway(),
  CodGateway.key: CodGateway(),
  BacsGateway.key: BacsGateway(),
};
