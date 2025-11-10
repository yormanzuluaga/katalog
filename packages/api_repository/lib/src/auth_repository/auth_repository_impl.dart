import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthResource authResource;
  @override
  AuthRepositoryImpl({
    required this.authResource,
  });

  @override
  Future<(ApiException?, bool?)> getVerification({
    required String mobile,
    required String code,
    Map<String, String>? headers,
  }) async {
    final authModel = await authResource.getVerification(
      mobile: mobile,
      code: code,
      headers: headers,
    );
    final leftResponse = authModel.$1;
    final rightResponse = authModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, UserModel?)> getVerificationCode({
    required String mobile,
    required String code,
    Map<String, String>? headers,
  }) async {
    final authModel = await authResource.getVerificationCode(
      mobile: mobile,
      code: code,
      headers: headers,
    );

    final leftResponse = authModel.$1;
    final rightResponse = authModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }
}
