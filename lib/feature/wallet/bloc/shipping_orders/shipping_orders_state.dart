part of 'shipping_orders_bloc.dart';

abstract class ShippingOrdersState extends Equatable {
  const ShippingOrdersState();

  @override
  List<Object> get props => [];
}

class ShippingOrdersInitial extends ShippingOrdersState {}

class ShippingOrdersLoading extends ShippingOrdersState {}

class ShippingOrdersLoaded extends ShippingOrdersState {
  const ShippingOrdersLoaded({
    required this.orders,
    required this.total,
    required this.hasMore,
  });

  final List<ShippingOrder> orders;
  final int total;
  final bool hasMore;

  @override
  List<Object> get props => [orders, total, hasMore];
}

class ShippingOrdersError extends ShippingOrdersState {
  const ShippingOrdersError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
