part of 'brand_bloc.dart';

class BrandState extends Equatable {
  const BrandState({
    this.brandId,
    this.brandName,
    this.products,
    this.message,
    this.brands,
  });

  final String? brandId;
  final String? brandName;
  final List<Product>? products;
  final List<BrandItem>? brands;

  final String? message;

  BrandState copyWith({
    String? brandId,
    String? brandName,
    List<Product>? products,
    String? message,
    List<BrandItem>? brands,
  }) {
    return BrandState(
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      products: products ?? this.products,
      message: message ?? this.message,
      brands: brands ?? this.brands,
    );
  }

  @override
  List<Object?> get props => [brandId, brandName, products, message, brands];
}
