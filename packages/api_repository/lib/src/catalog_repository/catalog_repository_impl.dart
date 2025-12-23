import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';

class CatalogRepositoryImpl extends CatalogRepository {
  CatalogRepositoryImpl({
    required this.catalogResource,
  });

  final CatalogResource catalogResource;

  @override
  Future<(ApiException?, CatalogActionResponse?)> createCatalog({
    required CreateCatalogRequest request,
    Map<String, String>? headers,
  }) async {
    final result = await catalogResource.createCatalog(
      request: request,
      headers: headers,
    );
    final leftResponse = result.$1;
    final rightResponse = result.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, CatalogListResponse?)> getMyCatalogs({
    Map<String, String>? headers,
  }) async {
    final result = await catalogResource.getMyCatalogs(
      headers: headers,
    );
    final leftResponse = result.$1;
    final rightResponse = result.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, CatalogDetailResponse?)> getCatalogById({
    required String catalogId,
    Map<String, String>? headers,
  }) async {
    final result = await catalogResource.getCatalogById(
      catalogId: catalogId,
      headers: headers,
    );
    final leftResponse = result.$1;
    final rightResponse = result.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, CatalogActionResponse?)> addProducts({
    required String catalogId,
    required AddProductsRequest request,
    Map<String, String>? headers,
  }) async {
    final result = await catalogResource.addProducts(
      catalogId: catalogId,
      request: request,
      headers: headers,
    );
    final leftResponse = result.$1;
    final rightResponse = result.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, CatalogActionResponse?)> deleteProduct({
    required String catalogId,
    required String productId,
    Map<String, String>? headers,
  }) async {
    final result = await catalogResource.deleteProduct(
      catalogId: catalogId,
      productId: productId,
      headers: headers,
    );
    final leftResponse = result.$1;
    final rightResponse = result.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, CatalogActionResponse?)> deleteCatalog({
    required String catalogId,
    Map<String, String>? headers,
  }) async {
    final result = await catalogResource.deleteCatalog(
      catalogId: catalogId,
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
