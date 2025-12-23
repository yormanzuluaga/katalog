import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';

/// Resource for brand-related API calls
class BrandResource {
  /// Get all brands
  ///
  BrandResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<(ApiException?, BrandListResponse?)> getBrands(
    Map<String, String>? headers,
  ) async {
    final response = await _apiClient.get(
      'api/brands',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final balanceResponse = BrandListResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, balanceResponse));
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

  /// Get products by brand ID
  Future<(ApiException?, BrandProductsResponse?)> getProductsByBrand(
    String brandId,
    Map<String, String>? headers,
  ) async {
    final response = await _apiClient.get(
      'api/products/brand/$brandId',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final brandProductsResponse = BrandProductsResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, brandProductsResponse));
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
