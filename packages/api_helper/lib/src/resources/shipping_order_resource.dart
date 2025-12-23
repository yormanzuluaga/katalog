import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';

/// {@template shipping_order_resource}
/// An api resource for shipping order operations.
/// {@endtemplate}
class ShippingOrderResource {
  /// {@macro shipping_order_resource}
  ShippingOrderResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Get my shipping orders
  ///
  /// GET /api/shipping-orders-v2/my-orders
  ///
  /// Returns a [ShippingOrdersResponse].
  Future<(ApiException?, ShippingOrdersResponse?)> getMyOrders({
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/shipping-orders-v2/my-orders',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final ordersResponse = ShippingOrdersResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, ordersResponse));
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

  /// Get pending shipping orders
  ///
  /// GET /api/shipping-orders-v2/pending-orders
  ///
  /// Returns a [ShippingOrdersResponse].
  Future<(ApiException?, ShippingOrdersResponse?)> getPendingOrders({
    Map<String, String>? headers,
  }) async {
    final response = await _apiClient.get(
      'api/shipping-orders-v2/pending-orders',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final ordersResponse = ShippingOrdersResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Future.value((null, ordersResponse));
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
