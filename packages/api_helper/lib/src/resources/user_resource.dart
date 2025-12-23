import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';

class UserResource {
  UserResource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<(ApiException?, UpdateUserResponse?)> updateUser({
    required String userId,
    Map<String, String>? headers,
    required Map<String, dynamic> data,
  }) async {
    final response = await _apiClient.put(
      'api/user/$userId',
      body: jsonEncode(data),
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final userResponse = UpdateUserResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, userResponse));
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

class UpdateUserResponse {
  const UpdateUserResponse({
    required this.success,
    this.message,
    this.user,
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      user: json['user'] != null
          ? Map<String, dynamic>.from(json['user'] as Map)
          : null,
    );
  }

  final bool success;
  final String? message;
  final Map<String, dynamic>? user;

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'user': user,
      };
}
