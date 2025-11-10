part of 'product_bloc.dart';

class ProductState extends Equatable {
  final String? message;
  // final List<ProductStoreModel>? productList;
  const ProductState({
    // this.productList,
    this.message,
  });

  ProductState copyWith({
    // List<ProductStoreModel>? productList,
    String? message,
  }) {
    return ProductState(
      // productList: productList ?? this.productList,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        // productList,
        message,
      ];
}
