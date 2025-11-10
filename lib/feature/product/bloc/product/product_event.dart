part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class GetProductEvent extends ProductEvent {
  final String id;
  final List<ProductCartModel> listSale;

  const GetProductEvent({required this.id, required this.listSale});
  @override
  List<Object?> get props => [id, listSale];
}

class CleanProductEvent extends ProductEvent {
  const CleanProductEvent();
  @override
  List<Object?> get props => [];
}
