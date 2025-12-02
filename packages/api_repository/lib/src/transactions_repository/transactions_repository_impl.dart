import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';
import 'package:api_repository/src/transactions_repository/transactions_repository.dart';

class TransactionsRepositoryImpl extends TransactionsRepository {
  TransactionsResource transactionsResource;
  @override
  TransactionsRepositoryImpl({
    required this.transactionsResource,
  });

  @override
  Future<(ApiException?, bool?)> createTransaction({
    required PaymentTransactionModel transaction,
    Map<String, String>? headers,
  }) async {
    final movieModel = await transactionsResource.createTransaction(
      transaction: transaction,
      headers: headers,
    );
    final leftResponse = movieModel.$1;
    final rightResponse = movieModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, true));
  }

  @override
  Future<(ApiException?, bool?)> getShippingOrders({
    Map<String, String>? headers,
  }) async {
    final movieModel = await transactionsResource.getShippingOrders(
      headers: headers,
    );
    final leftResponse = movieModel.$1;
    final rightResponse = movieModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, true));
  }
}
