import 'package:api_helper/api_helper.dart';
import 'package:api_repository/src/brand_repository/brand_repository.dart';

/// Implementation of BrandRepository
class BrandRepositoryImpl implements BrandRepository {
  final BrandResource _brandResource;
  @override
  BrandRepositoryImpl({required BrandResource brandResource})
      : _brandResource = brandResource;

  @override
  Future<(ApiException?, BrandListResponse?)> getBrands({
    Map<String, String>? headers,
  }) async {
    final movieModel = await _brandResource.getBrands(
      headers,
    );

    final leftResponse = movieModel.$1;
    final rightResponse = movieModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, BrandProductsResponse?)> getProductsByBrand({
    Map<String, String>? headers,
    required String brandId,
  }) async {
    final productModel = await _brandResource.getProductsByBrand(
      brandId,
      headers,
    );

    final leftResponse = productModel.$1;
    final rightResponse = productModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }
}
