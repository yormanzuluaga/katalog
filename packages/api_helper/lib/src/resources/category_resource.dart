import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';

/// {@template example_resource}
/// An api resource to get the prompt terms.
/// {@endtemplate}
class CategoryResource {
  /// {@macro example_resource}
  CategoryResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  // ignore: unused_field
  final ApiClient _apiClient;

  /// Get /game/prompt/terms
  ///
  /// Returns a [List<String>].
  Future<(ApiException?, CategoryModel?)> getCategory({
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/category',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final categoryResponse = CategoryModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, categoryResponse));
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

  Future<(ApiException?, SubCategoryModel?)> getSubCategory({
    required String idCategory,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/subcategory/$idCategory',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final categoryResponse = SubCategoryModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, categoryResponse));
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

  Future<(ApiException?, ProductModel?)> getProduct({
    required String idProduct,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/products/$idProduct',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final productResponse = ProductModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, productResponse));
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

  Future<(ApiException?, ProductModel?)> getProductByFilter({
    required String idProduct,
    required String filter,
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/products/filter/$filter',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final productResponse = ProductModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, productResponse));
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
