import 'package:api_helper/api_helper.dart';

abstract class TransactionsRepository {
  Future<(ApiException?, bool?)> createTransaction({
    required PaymentTransactionModel transaction,
    Map<String, String>? headers,
  });

  Future<(ApiException?, bool?)> getShippingOrders({
    Map<String, String>? headers,
  });
}
