import 'package:api_helper/api_helper.dart';

abstract class BalanceRepository {
  Future<(ApiException?, WalletBalanceResponse?)> getBalance({
    Map<String, String>? headers,
  });
}
