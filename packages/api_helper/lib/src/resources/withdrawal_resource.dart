import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';

/// {@template withdrawal_resource}
/// An api resource for withdrawal operations.
/// {@endtemplate}
class WithdrawalResource {
  /// {@macro withdrawal_resource}
  WithdrawalResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Request a withdrawal
  ///
  /// POST /api/withdrawals/request
  ///
  /// Returns a [WithdrawalResponse].
  Future<(ApiException?, WithdrawalResponse?)> requestWithdrawal({
    required WithdrawalRequest request,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.post(
      'api/withdrawals/request',
      body: jsonEncode(request.toJson()),
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      final withdrawalResponse = WithdrawalResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, withdrawalResponse));
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

  /// Get my withdrawals
  ///
  /// GET /api/withdrawals/my-withdrawals
  ///
  /// Returns a list of withdrawals.
  Future<(ApiException?, List<MyWithdrawal>?)> getMyWithdrawals({
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/withdrawals/my-withdrawals',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> withdrawalsList =
          jsonData['withdrawals'] as List<dynamic>;
      final withdrawals = withdrawalsList
          .map((json) => MyWithdrawal.fromJson(json as Map<String, dynamic>))
          .toList();
      return Future.value((null, withdrawals));
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
