part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryEvent extends CategoryEvent {
  const GetCategoryEvent();
  @override
  List<Object> get props => [];
}

class GetSubCategoryEvent extends CategoryEvent {
  final String idCategory;
  const GetSubCategoryEvent({required this.idCategory});

  @override
  List<Object> get props => [idCategory];
}

class GetProductEvent extends CategoryEvent {
  final String idProduct;
  const GetProductEvent({required this.idProduct});

  @override
  List<Object> get props => [idProduct];
}
