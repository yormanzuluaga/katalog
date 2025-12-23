import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';

/// {@template catalog_resource}
/// An api resource for catalog operations.
/// {@endtemplate}
class CatalogResource {
  /// {@macro catalog_resource}
  CatalogResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Create a new catalog
  /// POST api/catalogs-v2/create
  Future<(ApiException?, CatalogActionResponse?)> createCatalog({
    required CreateCatalogRequest request,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.post(
      'api/catalogs-v2/create',
      body: jsonEncode(request.toJson()),
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      final catalogResponse = CatalogActionResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, catalogResponse));
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

  /// Get my catalogs
  /// GET api/catalogs-v2/my-catalogs
  Future<(ApiException?, CatalogListResponse?)> getMyCatalogs({
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/catalogs-v2/my-catalogs',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final catalogResponse = CatalogListResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, catalogResponse));
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

  /// Get catalog by ID
  /// GET api/catalogs-v2/{catalogId}
  Future<(ApiException?, CatalogDetailResponse?)> getCatalogById({
    required String catalogId,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/catalogs-v2/$catalogId',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final catalogResponse = CatalogDetailResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, catalogResponse));
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

  /// Add products to catalog
  /// POST api/catalogs-v2/{catalogId}/products
  Future<(ApiException?, CatalogActionResponse?)> addProducts({
    required String catalogId,
    required AddProductsRequest request,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.post(
      'api/catalogs-v2/$catalogId/products',
      body: jsonEncode(request.toJson()),
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      final catalogResponse = CatalogActionResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, catalogResponse));
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

  /// Delete product from catalog
  /// DELETE api/catalogs-v2/{catalogId}/products/{productId}
  Future<(ApiException?, CatalogActionResponse?)> deleteProduct({
    required String catalogId,
    required String productId,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.delete(
      'api/catalogs-v2/$catalogId/products/$productId',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final catalogResponse = CatalogActionResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, catalogResponse));
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

  /// Delete catalog
  /// DELETE api/catalogs-v2/{catalogId}
  Future<(ApiException?, CatalogActionResponse?)> deleteCatalog({
    required String catalogId,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.delete(
      'api/catalogs-v2/$catalogId',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final catalogResponse = CatalogActionResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, catalogResponse));
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
