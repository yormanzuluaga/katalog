import 'package:equatable/equatable.dart';
import 'package:api_helper/api_helper.dart';

class CatalogListResponse extends Equatable {
  const CatalogListResponse({
    this.success,
    this.catalogs,
  });

  factory CatalogListResponse.fromJson(Map<String, dynamic> json) {
    return CatalogListResponse(
      success: json['success'] as bool?,
      catalogs: json['catalogs'] != null
          ? List<CatalogItem>.from(
              (json['catalogs'] as List).map((x) => CatalogItem.fromJson(x)),
            )
          : null,
    );
  }

  final bool? success;
  final List<CatalogItem>? catalogs;

  Map<String, dynamic> toJson() => {
        'success': success,
        'catalogs': catalogs?.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [success, catalogs];
}

class CatalogItem extends Equatable {
  const CatalogItem({
    this.id,
    this.name,
    this.description,
    this.settings,
    this.products,
    this.createdAt,
    this.updatedAt,
    this.owner,
  });

  factory CatalogItem.fromJson(Map<String, dynamic> json) {
    return CatalogItem(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      settings: json['settings'] != null
          ? CatalogSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : null,
      products: json['products'] != null
          ? List<CatalogProduct>.from(
              (json['products'] as List).map((x) => CatalogProduct.fromJson(x)),
            )
          : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      owner: json['owner'] as String?,
    );
  }

  final String? id;
  final String? name;
  final String? description;
  final CatalogSettings? settings;
  final List<CatalogProduct>? products;
  final String? createdAt;
  final String? updatedAt;
  final String? owner;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'description': description,
        'settings': settings?.toJson(),
        'products': products?.map((x) => x.toJson()).toList(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'owner': owner,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        settings,
        products,
        createdAt,
        updatedAt,
        owner,
      ];
}

class CatalogSettings extends Equatable {
  const CatalogSettings({
    this.isPublic,
    this.showPrices,
    this.theme,
    this.contactInfo,
  });

  factory CatalogSettings.fromJson(Map<String, dynamic> json) {
    return CatalogSettings(
      isPublic: json['isPublic'] as bool?,
      showPrices: json['showPrices'] as bool?,
      theme: json['theme'] != null
          ? CatalogTheme.fromJson(json['theme'] as Map<String, dynamic>)
          : null,
      contactInfo: json['contactInfo'] != null
          ? ContactInfo.fromJson(json['contactInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  final bool? isPublic;
  final bool? showPrices;
  final CatalogTheme? theme;
  final ContactInfo? contactInfo;

  Map<String, dynamic> toJson() => {
        'isPublic': isPublic,
        'showPrices': showPrices,
        'theme': theme?.toJson(),
        'contactInfo': contactInfo?.toJson(),
      };

  @override
  List<Object?> get props => [isPublic, showPrices, theme, contactInfo];
}

class CatalogTheme extends Equatable {
  const CatalogTheme({
    this.primaryColor,
    this.secondaryColor,
    this.logoUrl,
  });

  factory CatalogTheme.fromJson(Map<String, dynamic> json) {
    return CatalogTheme(
      primaryColor: json['primaryColor'] as String?,
      secondaryColor: json['secondaryColor'] as String?,
      logoUrl: json['logoUrl'] as String?,
    );
  }

  final String? primaryColor;
  final String? secondaryColor;
  final String? logoUrl;

  Map<String, dynamic> toJson() => {
        'primaryColor': primaryColor,
        'secondaryColor': secondaryColor,
        'logoUrl': logoUrl,
      };

  @override
  List<Object?> get props => [primaryColor, secondaryColor, logoUrl];
}

class ContactInfo extends Equatable {
  const ContactInfo({
    this.phone,
    this.email,
    this.whatsapp,
    this.socialMedia,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      whatsapp: json['whatsapp'] as String?,
      socialMedia: json['socialMedia'] != null
          ? SocialMedia.fromJson(json['socialMedia'] as Map<String, dynamic>)
          : null,
    );
  }

  final String? phone;
  final String? email;
  final String? whatsapp;
  final SocialMedia? socialMedia;

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'email': email,
        'whatsapp': whatsapp,
        'socialMedia': socialMedia?.toJson(),
      };

  @override
  List<Object?> get props => [phone, email, whatsapp, socialMedia];
}

class SocialMedia extends Equatable {
  const SocialMedia({
    this.instagram,
    this.facebook,
    this.tiktok,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      instagram: json['instagram'] as String?,
      facebook: json['facebook'] as String?,
      tiktok: json['tiktok'] as String?,
    );
  }

  final String? instagram;
  final String? facebook;
  final String? tiktok;

  Map<String, dynamic> toJson() => {
        'instagram': instagram,
        'facebook': facebook,
        'tiktok': tiktok,
      };

  @override
  List<Object?> get props => [instagram, facebook, tiktok];
}

class CatalogProduct extends Equatable {
  const CatalogProduct({
    this.productId,
    this.customPrice,
    this.sellerCommission,
    this.isAvailable,
    this.position,
    this.sellerNotes,
    this.customTags,
    this.isFeatured,
    this.product,
  });

  factory CatalogProduct.fromJson(Map<String, dynamic> json) {
    return CatalogProduct(
      productId: json['productId'] as String?,
      customPrice: json['customPrice'] != null
          ? (json['customPrice'] as num).toDouble()
          : null,
      sellerCommission: json['sellerCommission'] != null
          ? (json['sellerCommission'] as num).toDouble()
          : null,
      isAvailable: json['isAvailable'] as bool?,
      position: json['position'] as int?,
      sellerNotes: json['sellerNotes'] as String?,
      customTags: json['customTags'] != null
          ? List<String>.from(json['customTags'] as List)
          : null,
      isFeatured: json['isFeatured'] as bool?,
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  final String? productId;
  final double? customPrice;
  final double? sellerCommission;
  final bool? isAvailable;
  final int? position;
  final String? sellerNotes;
  final List<String>? customTags;
  final bool? isFeatured;
  final Product? product;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'customPrice': customPrice,
        'sellerCommission': sellerCommission,
        'isAvailable': isAvailable,
        'position': position,
        'sellerNotes': sellerNotes,
        'customTags': customTags,
        'isFeatured': isFeatured,
        'product': product?.toJson(),
      };

  @override
  List<Object?> get props => [
        productId,
        customPrice,
        sellerCommission,
        isAvailable,
        position,
        sellerNotes,
        customTags,
        isFeatured,
        product,
      ];
}

class CreateCatalogRequest extends Equatable {
  const CreateCatalogRequest({
    required this.name,
    this.description,
    this.settings,
    this.products,
  });

  factory CreateCatalogRequest.fromJson(Map<String, dynamic> json) {
    return CreateCatalogRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
      settings: json['settings'] != null
          ? CatalogSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : null,
      products: json['products'] != null
          ? List<CatalogProduct>.from(
              (json['products'] as List).map((x) => CatalogProduct.fromJson(x)),
            )
          : null,
    );
  }

  final String name;
  final String? description;
  final CatalogSettings? settings;
  final List<CatalogProduct>? products;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'settings': settings?.toJson(),
        'products': products?.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [name, description, settings, products];
}

class AddProductsRequest extends Equatable {
  const AddProductsRequest({
    required this.products,
  });

  factory AddProductsRequest.fromJson(Map<String, dynamic> json) {
    return AddProductsRequest(
      products: List<CatalogProduct>.from(
        (json['products'] as List).map((x) => CatalogProduct.fromJson(x)),
      ),
    );
  }

  final List<CatalogProduct> products;

  Map<String, dynamic> toJson() => {
        'products': products.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [products];
}

class CatalogDetailResponse extends Equatable {
  const CatalogDetailResponse({
    this.success,
    this.catalog,
  });

  factory CatalogDetailResponse.fromJson(Map<String, dynamic> json) {
    return CatalogDetailResponse(
      success: json['success'] as bool?,
      catalog: json['catalog'] != null
          ? CatalogItem.fromJson(json['catalog'] as Map<String, dynamic>)
          : null,
    );
  }

  final bool? success;
  final CatalogItem? catalog;

  Map<String, dynamic> toJson() => {
        'success': success,
        'catalog': catalog?.toJson(),
      };

  @override
  List<Object?> get props => [success, catalog];
}

class CatalogActionResponse extends Equatable {
  const CatalogActionResponse({
    this.success,
    this.message,
    this.catalog,
  });

  factory CatalogActionResponse.fromJson(Map<String, dynamic> json) {
    return CatalogActionResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      catalog: json['catalog'] != null
          ? CatalogItem.fromJson(json['catalog'] as Map<String, dynamic>)
          : null,
    );
  }

  final bool? success;
  final String? message;
  final CatalogItem? catalog;

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'catalog': catalog?.toJson(),
      };

  @override
  List<Object?> get props => [success, message, catalog];
}
