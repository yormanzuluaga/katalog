import 'package:api_helper/api_helper.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryRepository {
  Future<(ApiException?, CategoryModel?)> getCategory({
    Map<String, String>? headers,
  });
  Future<(ApiException?, SubCategoryModel?)> getSubCategory({
    required String idCategory,
    Map<String, String>? headers,
  });

  Future<(ApiException?, ProductModel?)> getProduct({
    required String idProduct,
    Map<String, String>? headers,
  });
}
