import 'package:api_helper/api_helper.dart';

abstract class WithdrawalRepository {
  Future<(ApiException?, WithdrawalResponse?)> requestWithdrawal({
    required WithdrawalRequest request,
    Map<String, String>? headers,
  });

  Future<(ApiException?, List<MyWithdrawal>?)> getMyWithdrawals({
    Map<String, String>? headers,
  });
}
