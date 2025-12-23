part of 'shipping_orders_bloc.dart';

abstract class ShippingOrdersEvent extends Equatable {
  const ShippingOrdersEvent();

  @override
  List<Object> get props => [];
}

class LoadMyOrders extends ShippingOrdersEvent {
  const LoadMyOrders();
}

class LoadPendingOrders extends ShippingOrdersEvent {
  const LoadPendingOrders();
}
