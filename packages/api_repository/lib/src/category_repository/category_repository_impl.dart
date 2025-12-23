import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  CategoryResource categoryResource;
  @override
  CategoryRepositoryImpl({
    required this.categoryResource,
  });

  @override
  Future<(ApiException?, CategoryModel?)> getCategory({
    Map<String, String>? headers,
  }) async {
    final movieModel = await categoryResource.getCategory(
      headers: headers,
    );
    final leftResponse = movieModel.$1;
    final rightResponse = movieModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, SubCategoryModel?)> getSubCategory({
    required String idCategory,
    Map<String, String>? headers,
  }) async {
    final movieModel = await categoryResource.getSubCategory(
      idCategory: idCategory,
      headers: headers,
    );
    final leftResponse = movieModel.$1;
    final rightResponse = movieModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, ProductModel?)> getProduct({
    required String idProduct,
    Map<String, String>? headers,
  }) async {
    final movieModel = await categoryResource.getProduct(
      idProduct: idProduct,
      headers: headers,
    );
    final leftResponse = movieModel.$1;
    final rightResponse = movieModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, ProductModel?)> getProductByFilter({
    required String idProduct,
    required String filter,
    Map<String, String>? headers,
  }) async {
    final movieModel = await categoryResource.getProductByFilter(
      idProduct: idProduct,
      filter: filter,
      headers: headers,
    );
    final leftResponse = movieModel.$1;
    final rightResponse = movieModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }
}
