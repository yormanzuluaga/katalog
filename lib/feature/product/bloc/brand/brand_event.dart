part of 'brand_bloc.dart';

abstract class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object?> get props => [];
}

class LoadBrands extends BrandEvent {
  const LoadBrands();
}

class LoadProductsByBrand extends BrandEvent {
  final String brandId;
  final String brandName;

  const LoadProductsByBrand({
    required this.brandId,
    required this.brandName,
  });

  @override
  List<Object?> get props => [brandId, brandName];
}
