import 'package:api_helper/api_helper.dart';

abstract class UserRepository {
  Future<(ApiException?, UserModel?)> createUser({
    required String firstName,
    required String lastName,
    required String mobile,
    required String countryCode,
    String? email,
    Map<String, String>? headers,
  });

  Future<(ApiException?, UpdateUserResponse?)> updateUser({
    required String userId,
    required String firstName,
    required String lastName,
    String? mobile,
    Map<String, String>? headers,
  });
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserResource userResource})
      : _userResource = userResource;

  final UserResource _userResource;

  @override
  Future<(ApiException?, UserModel?)> createUser({
    required String firstName,
    required String lastName,
    required String mobile,
    required String countryCode,
    String? email,
    Map<String, String>? headers,
  }) async {
    final data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email ?? '',
      'password': '',
      'countryCode': countryCode,
      'mobile': mobile,
      'collaborator': '',
      'rol': 'USER_ROLE',
      'avatar': '',
      'estado': true,
      'google': false,
      'apple': false,
      'facebook': false,
      'location': '',
      'date': DateTime.now().toIso8601String(),
    };

    print('User data being sent: $data'); // Debug

    return await _userResource.createUser(
      data: data,
      headers: headers,
    );
  }

  @override
  Future<(ApiException?, UpdateUserResponse?)> updateUser({
    required String userId,
    required String firstName,
    required String lastName,
    String? mobile,
    Map<String, String>? headers,
  }) async {
    final data = {
      'firstName': firstName,
      'lastName': lastName,
      if (mobile != null && mobile.isNotEmpty) 'mobile': mobile,
    };

    final result = await _userResource.updateUser(
      userId: userId,
      data: data,
      headers: headers,
    );

    final leftResponse = result.$1;
    final rightResponse = result.$2;

    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }

    return Future.value((null, rightResponse));
  }
}
