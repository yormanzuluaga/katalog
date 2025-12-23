// ignore_for_file: must_be_immutable

part of 'category_bloc.dart';

class CategoryState extends Equatable {
  const CategoryState({
    this.category,
    this.subCategory,
    this.product,
    this.url = '',
    this.selectedFilter,
    this.message,
    this.brands,
    this.currentBrandId,
    this.currentType,
  });

  final CategoryModel? category;
  final SubCategoryModel? subCategory;
  final ProductModel? product;
  final String url;
  final String? selectedFilter;
  final String? message;
  final List<BrandItem>? brands;
  final String? currentBrandId;
  final String? currentType; // 'brand' o 'category'

  CategoryState copyWith({
    CategoryModel? category,
    SubCategoryModel? subCategory,
    ProductModel? product,
    String? url,
    String? selectedFilter,
    String? message,
    List<BrandItem>? brands,
    String? currentBrandId,
    String? currentType,
    bool clearFilter = false,
  }) {
    return CategoryState(
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      product: product ?? this.product,
      url: url ?? this.url,
      selectedFilter:
          clearFilter ? null : (selectedFilter ?? this.selectedFilter),
      message: message ?? this.message,
      brands: brands ?? this.brands,
      currentBrandId: currentBrandId ?? this.currentBrandId,
      currentType: currentType ?? this.currentType,
    );
  }

  @override
  List<Object?> get props => [
        category,
        subCategory,
        product,
        url,
        selectedFilter,
        message,
        brands,
        currentBrandId,
        currentType,
      ];
}
