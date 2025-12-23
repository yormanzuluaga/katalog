part of 'product_bloc.dart';

class ProductState extends Equatable {
  final String? message;
  final ProductModel? productModel;
  final String? selectedFilter;
  final bool isLoading;

  const ProductState({
    this.message,
    this.productModel,
    this.selectedFilter,
    this.isLoading = false,
  });

  ProductState copyWith({
    String? message,
    ProductModel? productModel,
    String? selectedFilter,
    bool? isLoading,
    bool clearFilter = false,
  }) {
    return ProductState(
      message: message ?? this.message,
      productModel: productModel ?? this.productModel,
      selectedFilter:
          clearFilter ? null : (selectedFilter ?? this.selectedFilter),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        message,
        productModel,
        selectedFilter,
        isLoading,
      ];
}
