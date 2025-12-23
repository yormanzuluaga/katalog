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

class LoadProductsByCategoryEvent extends ProductEvent {
  final String categoryId;
  const LoadProductsByCategoryEvent({required this.categoryId});
  @override
  List<Object?> get props => [categoryId];
}

class FilterProductsEvent extends ProductEvent {
  final String categoryId;
  final String filter;
  const FilterProductsEvent({required this.categoryId, required this.filter});
  @override
  List<Object?> get props => [categoryId, filter];
}

class ClearProductFilterEvent extends ProductEvent {
  final String categoryId;
  const ClearProductFilterEvent({required this.categoryId});
  @override
  List<Object?> get props => [categoryId];
}
