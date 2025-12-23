import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';

class BannerResource {
  BannerResource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<(ApiException?, BannerResponse?)> getBanners(
    Map<String, String>? headers,
  ) async {
    final response = await _apiClient.get(
      'api/banners',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final bannerResponse = BannerResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, bannerResponse));
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
