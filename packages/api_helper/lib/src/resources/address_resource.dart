import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';

/// {@template example_resource}
/// An api resource to get the prompt terms.
/// {@endtemplate}
class AddressResource {
  /// {@macro example_resource}
  AddressResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  // ignore: unused_field
  final ApiClient _apiClient;

  /// Get /game/prompt/terms
  ///
  /// Returns a [List<String>].
  Future<(ApiException?, AddressModel?)> getAddress({
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/addresses',
      modifiedHeaders: headers,
    );
    if (response.statusCode == HttpStatus.ok) {
      final addressResponse = AddressModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, addressResponse));
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

  Future<(ApiException?, bool?)> postAddress({
    required AddressUserModel address,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.post(
      'api/addresses',
      body: jsonEncode(address),
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      return Future.value((null, true));
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

  Future<(ApiException?, AddressModel?)> updateAddress({
    required String idAddress,
    required AddressUserModel address,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.put(
      'api/addresses/$idAddress',
      body: address.toJson(),
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final addressResponse = AddressModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, addressResponse));
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

  Future<(ApiException?, AddressModel?)> deleteAddress({
    required String idAddress,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.delete(
      'api/addresses/$idAddress',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final addressResponse = AddressModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, addressResponse));
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
