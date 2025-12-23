import 'package:api_helper/api_helper.dart';

/// Abstract repository for brand operations
abstract class BrandRepository {
  /// Get all brands
  Future<(ApiException?, BrandListResponse?)> getBrands({
    Map<String, String>? headers,
  });

  /// Get products by brand ID
  Future<(ApiException?, BrandProductsResponse?)> getProductsByBrand({
    required String brandId,
    Map<String, String>? headers,
  });
}
