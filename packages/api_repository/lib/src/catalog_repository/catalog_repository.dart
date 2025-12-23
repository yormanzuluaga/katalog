import 'package:api_helper/api_helper.dart';

abstract class CatalogRepository {
  Future<(ApiException?, CatalogActionResponse?)> createCatalog({
    required CreateCatalogRequest request,
    Map<String, String>? headers,
  });

  Future<(ApiException?, CatalogListResponse?)> getMyCatalogs({
    Map<String, String>? headers,
  });

  Future<(ApiException?, CatalogDetailResponse?)> getCatalogById({
    required String catalogId,
    Map<String, String>? headers,
  });

  Future<(ApiException?, CatalogActionResponse?)> addProducts({
    required String catalogId,
    required AddProductsRequest request,
    Map<String, String>? headers,
  });

  Future<(ApiException?, CatalogActionResponse?)> deleteProduct({
    required String catalogId,
    required String productId,
    Map<String, String>? headers,
  });

  Future<(ApiException?, CatalogActionResponse?)> deleteCatalog({
    required String catalogId,
    Map<String, String>? headers,
  });
}
