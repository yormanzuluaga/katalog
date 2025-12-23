import 'package:api_helper/api_helper.dart';
import 'package:api_repository/src/shipping_order_repository/shipping_order_repository.dart';

class ShippingOrderRepositoryImpl extends ShippingOrderRepository {
  ShippingOrderRepositoryImpl({
    required ShippingOrderResource shippingOrderResource,
  }) : _shippingOrderResource = shippingOrderResource;

  final ShippingOrderResource _shippingOrderResource;

  @override
  Future<(ApiException?, ShippingOrdersResponse?)> getMyOrders({
    Map<String, String>? headers,
  }) {
    return _shippingOrderResource.getMyOrders(headers: headers);
  }

  @override
  Future<(ApiException?, ShippingOrdersResponse?)> getPendingOrders({
    Map<String, String>? headers,
  }) {
    return _shippingOrderResource.getPendingOrders(headers: headers);
  }
}
