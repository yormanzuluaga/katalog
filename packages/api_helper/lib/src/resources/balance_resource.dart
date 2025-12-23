import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';

/// {@template balance_resource}
/// An api resource for wallet balance operations.
/// {@endtemplate}
class BalanceResource {
  /// {@macro balance_resource}
  BalanceResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Get wallet balance
  ///
  /// GET /api/wallet/balance
  ///
  /// Returns a [WalletBalanceResponse].
  Future<(ApiException?, WalletBalanceResponse?)> getBalance({
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/wallet/balance',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final balanceResponse = WalletBalanceResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, balanceResponse));
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
