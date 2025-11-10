// ignore_for_file: must_be_immutable

part of 'category_bloc.dart';

class CategoryState extends Equatable {
  const CategoryState({
    this.category,
    this.subCategory,
    this.product,
    this.url = '',
  });

  final CategoryModel? category;
  final SubCategoryModel? subCategory;
  final ProductModel? product;
  final String url;

  CategoryState copyWith({
    CategoryModel? category,
    SubCategoryModel? subCategory,
    ProductModel? product,
    String? url,
  }) {
    return CategoryState(
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      product: product ?? this.product,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [
        category,
        subCategory,
        product,
        url,
      ];
}
