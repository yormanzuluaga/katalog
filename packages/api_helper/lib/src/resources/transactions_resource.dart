import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';

/// {@template transactions_resource}
/// An api resource for transaction operations.
/// {@endtemplate}
class TransactionsResource {
  /// {@macro transactions_resource}
  TransactionsResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Create a new transaction
  ///
  /// POST /api/transactions
  ///
  /// Returns a [TransactionResponse].
  Future<(ApiException?, bool?)> createTransaction({
    required PaymentTransactionModel transaction,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.post(
      'api/transactions',
      body: jsonEncode(transaction.toJson()),
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      return Future.value((null, true));
    } else {
      return Future.value(
        (
          ApiException(
            response.statusCode,
            response.body,
          ),
          null,
        ),
      );
    }
  }

  Future<(ApiException?, bool?)> getShippingOrders({
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/shipping-orders/my-orders',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      return Future.value((null, true));
    } else {
      return Future.value(
        (
          ApiException(
            response.statusCode,
            response.body,
          ),
          null,
        ),
      );
    }
  }
}
