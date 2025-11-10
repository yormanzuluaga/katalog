import 'package:api_helper/api_helper.dart';

abstract class AuthRepository {
  Future<(ApiException?, bool?)> getVerification({
    required String mobile,
    required String code,
    Map<String, String>? headers,
  });

  Future<(ApiException?, UserModel?)> getVerificationCode({
    required String mobile,
    required String code,
    Map<String, String>? headers,
  });
}
