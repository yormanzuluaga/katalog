part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddCartEvent extends CartEvent {
  final int? index;
  final Product productsSalesModel;

  const AddCartEvent({
    this.index,
    required this.productsSalesModel,
  });

  @override
  List<Object?> get props => [
        index,
        productsSalesModel,
      ];
}

class DeletedCartEvent extends CartEvent {
  final String? id;

  const DeletedCartEvent({
    this.id,
  });

  @override
  List<Object?> get props => [id];
}

class CountCartEvent extends CartEvent {
  final String id;
  final int quantity;

  const CountCartEvent({required this.id, required this.quantity});

  @override
  List<Object?> get props => [id, quantity];
}

class FinalSalesEvent extends CartEvent {
  const FinalSalesEvent();

  @override
  List<Object?> get props => [];
}
