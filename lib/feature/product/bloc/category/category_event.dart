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
  final String? title;
  const GetProductEvent({required this.idProduct, this.title});

  @override
  List<Object> get props => [idProduct, title ?? ''];
}

class FilterProductEvent extends CategoryEvent {
  final String idProduct;
  final String filter;
  const FilterProductEvent({required this.idProduct, required this.filter});

  @override
  List<Object> get props => [idProduct, filter];
}

class ClearFilterEvent extends CategoryEvent {
  final String idProduct;
  const ClearFilterEvent({required this.idProduct});

  @override
  List<Object> get props => [idProduct];
}

class LoadBrandsEvent extends CategoryEvent {
  const LoadBrandsEvent();

  @override
  List<Object> get props => [];
}

class LoadProductsByBrandEvent extends CategoryEvent {
  final String brandId;
  final String brandName;

  const LoadProductsByBrandEvent({
    required this.brandId,
    required this.brandName,
  });

  @override
  List<Object> get props => [brandId, brandName];
}
