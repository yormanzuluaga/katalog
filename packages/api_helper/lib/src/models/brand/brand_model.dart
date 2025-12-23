import 'package:equatable/equatable.dart';
import 'package:api_helper/src/models/category/product_model.dart';

/// Response model for brands list API
class BrandListResponse extends Equatable {
  final List<BrandItem> brands;

  const BrandListResponse({
    required this.brands,
  });

  factory BrandListResponse.fromJson(Map<String, dynamic> json) {
    return BrandListResponse(
      brands: json['brands'] != null
          ? List<BrandItem>.from(
              json['brands'].map((x) => BrandItem.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'brands': brands.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [brands];
}

/// Individual brand item
class BrandItem extends Equatable {
  final String id;
  final String name;
  final String? logo;
  final String? description;

  const BrandItem({
    required this.id,
    required this.name,
    this.logo,
    this.description,
  });

  factory BrandItem.fromJson(Map<String, dynamic> json) {
    return BrandItem(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'logo': logo,
        'description': description,
      };

  @override
  List<Object?> get props => [id, name, logo, description];
}

/// Response model for products by brand API
class BrandProductsResponse extends Equatable {
  final bool success;
  final BrandItem brand;
  final int totalProducts;
  final int from;
  final int limit;
  final List<String> availableFilters;
  final List<Product> products;
  final PaginationInfo pagination;

  const BrandProductsResponse({
    required this.success,
    required this.brand,
    required this.totalProducts,
    required this.from,
    required this.limit,
    required this.availableFilters,
    required this.products,
    required this.pagination,
  });

  factory BrandProductsResponse.fromJson(Map<String, dynamic> json) {
    return BrandProductsResponse(
      success: json['success'] ?? false,
      brand: BrandItem.fromJson(json['brand'] ?? {}),
      totalProducts: json['totalProducts'] ?? 0,
      from: json['from'] ?? 0,
      limit: json['limit'] ?? 10,
      availableFilters: json['availableFilters'] != null
          ? List<String>.from(json['availableFilters'])
          : [],
      products: json['products'] != null
          ? List<Product>.from(
              json['products'].map((x) => Product.fromJson(x)),
            )
          : [],
      pagination: json['pagination'] != null
          ? PaginationInfo.fromJson(json['pagination'])
          : const PaginationInfo(hasMore: false),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'brand': brand.toJson(),
        'totalProducts': totalProducts,
        'from': from,
        'limit': limit,
        'availableFilters': availableFilters,
        'products': products.map((x) => x.toJson()).toList(),
        'pagination': pagination.toJson(),
      };

  @override
  List<Object?> get props => [
        success,
        brand,
        totalProducts,
        from,
        limit,
        availableFilters,
        products,
        pagination,
      ];
}

/// Pagination information
class PaginationInfo extends Equatable {
  final bool hasMore;

  const PaginationInfo({
    required this.hasMore,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      hasMore: json['hasMore'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'hasMore': hasMore,
      };

  @override
  List<Object?> get props => [hasMore];
}
