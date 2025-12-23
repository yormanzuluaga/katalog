import 'package:api_helper/api_helper.dart';
import 'package:api_repository/src/balance_repository/balance_repository.dart';

class BalanceRepositoryImpl extends BalanceRepository {
  BalanceRepositoryImpl({
    required BalanceResource balanceResource,
  }) : _balanceResource = balanceResource;

  final BalanceResource _balanceResource;

  @override
  Future<(ApiException?, WalletBalanceResponse?)> getBalance({
    Map<String, String>? headers,
  }) {
    return _balanceResource.getBalance(headers: headers);
  }
}
