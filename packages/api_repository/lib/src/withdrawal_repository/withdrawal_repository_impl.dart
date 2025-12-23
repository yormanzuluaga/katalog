import 'package:api_helper/api_helper.dart';
import 'package:api_repository/src/withdrawal_repository/withdrawal_repository.dart';

class WithdrawalRepositoryImpl extends WithdrawalRepository {
  WithdrawalRepositoryImpl({
    required WithdrawalResource withdrawalResource,
  }) : _withdrawalResource = withdrawalResource;

  final WithdrawalResource _withdrawalResource;

  @override
  Future<(ApiException?, WithdrawalResponse?)> requestWithdrawal({
    required WithdrawalRequest request,
    Map<String, String>? headers,
  }) {
    return _withdrawalResource.requestWithdrawal(
      request: request,
      headers: headers,
    );
  }

  @override
  Future<(ApiException?, List<MyWithdrawal>?)> getMyWithdrawals({
    Map<String, String>? headers,
  }) {
    return _withdrawalResource.getMyWithdrawals(headers: headers);
  }
}
