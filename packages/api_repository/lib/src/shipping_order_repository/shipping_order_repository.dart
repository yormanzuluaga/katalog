import 'package:api_helper/api_helper.dart';

abstract class ShippingOrderRepository {
  Future<(ApiException?, ShippingOrdersResponse?)> getMyOrders({
    Map<String, String>? headers,
  });

  Future<(ApiException?, ShippingOrdersResponse?)> getPendingOrders({
    Map<String, String>? headers,
  });
}
