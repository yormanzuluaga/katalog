import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';

/// {@template example_resource}
/// An api resource to get the prompt terms.
/// {@endtemplate}
class AuthResource {
  /// {@macro example_resource}
  AuthResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  // ignore: unused_field
  final ApiClient _apiClient;

  /// Get /api/auth/sms/verification
  ///
  /// Returns a [bool] indicating if verification was successful.
  Future<(ApiException?, bool?)> getVerification({
    required String mobile,
    required String code,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _apiClient.get(
        'api/auth/sms/+$code$mobile',
        modifiedHeaders: headers,
      );

      if (response.statusCode == HttpStatus.ok) {
        return Future.value((null, true));
      } else {
        return Future.value((
          ApiException(
            response.statusCode,
            response.body,
          ),
          null,
        ));
      }
    } catch (e, stackTrace) {
      print('Error in getVerification: $e'); // Debug log
      print('StackTrace: $stackTrace'); // Debug log
      return Future.value((
        ApiException(
          500,
          'Unexpected error: $e',
        ),
        null
      ));
    }
  }

  Future<(ApiException?, UserModel?)> getVerificationCode({
    required String mobile,
    required String code,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _apiClient.get(
        'api/auth/verify/$mobile/$code',
        modifiedHeaders: headers,
      );

      if (response.statusCode == HttpStatus.ok) {
        final userModel = UserModel.fromJson(jsonDecode(response.body));
        return Future.value((null, userModel));
      } else {
        return Future.value((
          ApiException(
            response.statusCode,
            response.body,
          ),
          null,
        ));
      }
    } catch (e, stackTrace) {
      print('Error in getVerification: $e'); // Debug log
      print('StackTrace: $stackTrace'); // Debug log
      return Future.value((
        ApiException(
          500,
          'Unexpected error: $e',
        ),
        null
      ));
    }
  }
}
