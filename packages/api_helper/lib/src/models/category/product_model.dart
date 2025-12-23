import 'sub_category_model.dart';

class ProductModel {
  int? allProduct;
  List<Product>? product;
  String? type;
  List<String>? availableFilters;
  bool? success;
  int? total;
  String? filter;
  Pagination? pagination;

  ProductModel({
    this.allProduct,
    this.product,
    this.type,
    this.availableFilters,
    this.success,
    this.total,
    this.filter,
    this.pagination,
  });

  ProductModel copyWith({
    int? allProduct,
    List<Product>? product,
    String? type,
    List<String>? availableFilters,
    bool? success,
    int? total,
    String? filter,
    Pagination? pagination,
  }) =>
      ProductModel(
        allProduct: allProduct ?? this.allProduct,
        product: product ?? this.product,
        type: type ?? this.type,
        availableFilters: availableFilters ?? this.availableFilters,
        success: success ?? this.success,
        total: total ?? this.total,
        filter: filter ?? this.filter,
        pagination: pagination ?? this.pagination,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Manejar respuesta de filtro (con "products") o respuesta normal (con "product")
    List<Product>? productList;
    if (json["products"] != null) {
      productList =
          List<Product>.from(json["products"].map((x) => Product.fromJson(x)));
    } else if (json["product"] != null) {
      productList =
          List<Product>.from(json["product"].map((x) => Product.fromJson(x)));
    }

    return ProductModel(
      allProduct: json["allProduct"] ?? json["total"],
      product: productList,
      type: json["type"],
      availableFilters: json["availableFilters"] != null
          ? List<String>.from(json["availableFilters"])
          : null,
      success: json["success"],
      total: json["total"],
      filter: json["filter"],
      pagination: json["pagination"] != null
          ? Pagination.fromJson(json["pagination"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "allProduct": allProduct,
        "product": List<dynamic>.from(product?.map((x) => x.toJson()) ?? []),
        "type": type,
        "availableFilters": availableFilters != null
            ? List<dynamic>.from(availableFilters!)
            : null,
        "success": success,
        "total": total,
        "filter": filter,
        "pagination": pagination?.toJson(),
      };
}

class Product {
  String? id;
  String? name;
  int? quantity;

  String? model;
  Brand? brand;
  String? urlVideo;
  bool? estado;
  List<CountryCode>? countryCodes;
  List<City>? cities;
  Users? user;
  SubCategory? subCategory;
  int? basePrice;
  Pricing? pricing;
  Points? points;
  List<Variant>? variants;
  SimpleProduct? simpleProduct;
  List<Discount>? discount;
  String? deliveryTime;
  String? description;
  Details? details;
  Warranty? warranty;
  bool? available;
  String? img;
  List<String>? images;
  String? productType;
  DateTime? createdAt;
  DateTime? updatedAt;

  Product({
    this.id,
    this.name,
    this.model,
    this.quantity,
    this.brand,
    this.urlVideo,
    this.estado,
    this.countryCodes,
    this.cities,
    this.user,
    this.subCategory,
    this.basePrice,
    this.pricing,
    this.points,
    this.variants,
    this.simpleProduct,
    this.discount,
    this.deliveryTime,
    this.description,
    this.details,
    this.warranty,
    this.available,
    this.img,
    this.images,
    this.productType,
    this.createdAt,
    this.updatedAt,
  });

  Product copyWith({
    String? id,
    String? name,
    String? model,
    Brand? brand,
    String? urlVideo,
    bool? estado,
    int? quantity,
    List<CountryCode>? countryCodes,
    List<City>? cities,
    Users? user,
    SubCategory? subCategory,
    int? basePrice,
    Pricing? pricing,
    Points? points,
    List<Variant>? variants,
    SimpleProduct? simpleProduct,
    List<Discount>? discount,
    String? deliveryTime,
    String? description,
    Details? details,
    Warranty? warranty,
    bool? available,
    String? img,
    List<String>? images,
    String? productType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        model: model ?? this.model,
        brand: brand ?? this.brand,
        quantity: quantity ?? this.quantity,
        urlVideo: urlVideo ?? this.urlVideo,
        estado: estado ?? this.estado,
        countryCodes: countryCodes ?? this.countryCodes,
        cities: cities ?? this.cities,
        user: user ?? this.user,
        subCategory: subCategory ?? this.subCategory,
        basePrice: basePrice ?? this.basePrice,
        pricing: pricing ?? this.pricing,
        points: points ?? this.points,
        variants: variants ?? this.variants,
        simpleProduct: simpleProduct ?? this.simpleProduct,
        discount: discount ?? this.discount,
        deliveryTime: deliveryTime ?? this.deliveryTime,
        description: description ?? this.description,
        details: details ?? this.details,
        warranty: warranty ?? this.warranty,
        available: available ?? this.available,
        img: img ?? this.img,
        images: images ?? this.images,
        productType: productType ?? this.productType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Product.fromJson(Map<String, dynamic> json) {
    final id = json["_id"];
    final name = json["name"];
    final model = json["model"];

    final brand = json["brand"] != null ? _parseBrand(json["brand"]) : null;
    final quantity = json["quantity"];

    final countryCodes = json["countryCodes"] != null
        ? List<CountryCode>.from(json["countryCodes"].map((x) {
            return CountryCode.fromJson(x);
          }))
        : null;

    final cities = json["cities"] != null
        ? List<City>.from(json["cities"].map((x) {
            return City.fromJson(x);
          }))
        : null;

    final user = json["user"] != null ? Users.fromJson(json["user"]) : null;

    final subCategory = json["subCategory"] != null
        ? _parseSubCategoryFromProduct(json["subCategory"])
        : null;

    final pricing =
        json["pricing"] != null ? Pricing.fromJson(json["pricing"]) : null;

    final points =
        json["points"] != null ? Points.fromJson(json["points"]) : null;

    final variants = json["variants"] != null
        ? List<Variant>.from(json["variants"].map((x) {
            return Variant.fromJson(x);
          }))
        : null;

    final simpleProduct = json["simpleProduct"] != null
        ? SimpleProduct.fromJson(json["simpleProduct"])
        : null;
    final discount = json["discount"] != null
        ? List<Discount>.from(json["discount"].map((x) {
            return Discount.fromJson(x);
          }))
        : null;

    final details =
        json["details"] != null ? Details.fromJson(json["details"]) : null;

    final warranty =
        json["warranty"] != null ? Warranty.fromJson(json["warranty"]) : null;

    final images = json["images"] != null
        ? List<String>.from(json["images"].map((x) => x))
        : null;

    return Product(
      id: id,
      name: name,
      model: model,
      brand: brand,
      urlVideo: json["urlVideo"],
      estado: json["estado"],
      countryCodes: countryCodes,
      cities: cities,
      quantity: quantity,
      user: user,
      subCategory: subCategory,
      basePrice: json["basePrice"],
      pricing: pricing,
      points: points,
      variants: variants,
      simpleProduct: simpleProduct,
      discount: discount,
      deliveryTime: json["deliveryTime"],
      description: json["description"],
      details: details,
      warranty: warranty,
      available: json["available"],
      img: json["img"],
      images: images,
      productType: json["productType"],
      createdAt:
          json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
      updatedAt:
          json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
    );
  }

  static SubCategory? _parseSubCategoryFromProduct(Map<String, dynamic> json) {
    return SubCategory(
      id: json["_id"],
      name: json["name"],
      description: null,
      category: json["category"] != null
          ? Categorys.fromJson(json["category"])
          : null,
      img: null,
      estado: null,
      user: null,
      createdAt: null,
      updatedAt: null,
    );
  }

  static Brand? _parseBrand(dynamic brandData) {
    if (brandData is String) {
      return Brand(
        id: brandData,
        name: null,
        logo: null,
      );
    } else if (brandData is Map<String, dynamic>) {
      return Brand.fromJson(brandData);
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "model": model,
        'quantity': quantity,
        "brand": brand?.toJson(),
        "urlVideo": urlVideo,
        "estado": estado,
        "countryCodes": countryCodes != null
            ? List<dynamic>.from(countryCodes!.map((x) => x.toJson()))
            : null,
        "cities": cities != null
            ? List<dynamic>.from(cities!.map((x) => x.toJson()))
            : null,
        "user": user?.toJson(),
        "subCategory": subCategory?.toJson(),
        "basePrice": basePrice,
        "pricing": pricing?.toJson(),
        "points": points?.toJson(),
        "variants": variants != null
            ? List<dynamic>.from(variants!.map((x) => x.toJson()))
            : null,
        "simpleProduct": simpleProduct?.toJson(),
        "discount": discount != null
            ? List<dynamic>.from(discount!.map((x) => x.toJson()))
            : null,
        "deliveryTime": deliveryTime,
        "description": description,
        "details": details?.toJson(),
        "warranty": warranty?.toJson(),
        "available": available,
        "img": img,
        "images":
            images != null ? List<dynamic>.from(images!.map((x) => x)) : null,
        "productType": productType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Brand {
  String? id;
  String? name;
  String? logo;

  Brand({
    this.id,
    this.name,
    this.logo,
  });

  Brand copyWith({
    String? id,
    String? name,
    String? logo,
  }) =>
      Brand(
        id: id ?? this.id,
        name: name ?? this.name,
        logo: logo ?? this.logo,
      );

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["_id"],
        name: json["name"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "logo": logo,
      };
}

class City {
  String? id;
  String? city;

  City({
    this.id,
    this.city,
  });

  City copyWith({
    String? id,
    String? city,
  }) =>
      City(
        id: id ?? this.id,
        city: city ?? this.city,
      );

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["_id"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "city": city,
      };
}

class CountryCode {
  String? id;
  String? countryCode;

  CountryCode({
    this.id,
    this.countryCode,
  });

  CountryCode copyWith({
    String? id,
    String? countryCode,
  }) =>
      CountryCode(
        id: id ?? this.id,
        countryCode: countryCode ?? this.countryCode,
      );

  factory CountryCode.fromJson(Map<String, dynamic> json) => CountryCode(
        id: json["_id"],
        countryCode: json["countryCode"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "countryCode": countryCode,
      };
}

class Details {
  List<Specification>? specifications;
  List<String>? features;
  List<String>? included;
  String? instructions;
  String? careInstructions;

  Details({
    this.specifications,
    this.features,
    this.included,
    this.instructions,
    this.careInstructions,
  });

  Details copyWith({
    List<Specification>? specifications,
    List<String>? features,
    List<String>? included,
    String? instructions,
    String? careInstructions,
  }) =>
      Details(
        specifications: specifications ?? this.specifications,
        features: features ?? this.features,
        included: included ?? this.included,
        instructions: instructions ?? this.instructions,
        careInstructions: careInstructions ?? this.careInstructions,
      );

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      specifications: json["specifications"] != null
          ? List<Specification>.from(json["specifications"].map((x) {
              return Specification.fromJson(x);
            }))
          : null,
      features: json["features"] != null
          ? List<String>.from(json["features"].map((x) => x))
          : null,
      included: json["included"] != null
          ? List<String>.from(json["included"].map((x) => x))
          : null,
      instructions: json["instructions"],
      careInstructions: json["careInstructions"],
    );
  }

  Map<String, dynamic> toJson() => {
        "specifications":
            List<dynamic>.from(specifications!.map((x) => x.toJson())),
        "features": List<dynamic>.from(features!.map((x) => x)),
        "included": List<dynamic>.from(included!.map((x) => x)),
        "instructions": instructions,
        "careInstructions": careInstructions,
      };
}

class Specification {
  String? id;
  String? name;
  String? value;
  String? unit;

  Specification({
    this.id,
    this.name,
    this.value,
    this.unit,
  });

  Specification copyWith({
    String? id,
    String? name,
    String? value,
    String? unit,
  }) =>
      Specification(
        id: id ?? this.id,
        name: name ?? this.name,
        value: value ?? this.value,
        unit: unit ?? this.unit,
      );

  factory Specification.fromJson(Map<String, dynamic> json) => Specification(
        id: json["_id"],
        name: json["name"],
        value: json["value"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "value": value,
        "unit": unit,
      };
}

class Discount {
  String? id;
  String? type;
  int? value;
  DateTime? startDate;
  DateTime? endDate;
  int? minQuantity;

  Discount({
    this.id,
    this.type,
    this.value,
    this.startDate,
    this.endDate,
    this.minQuantity,
  });

  Discount copyWith({
    String? id,
    String? type,
    int? value,
    DateTime? startDate,
    DateTime? endDate,
    int? minQuantity,
  }) =>
      Discount(
        id: id ?? this.id,
        type: type ?? this.type,
        value: value ?? this.value,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        minQuantity: minQuantity ?? this.minQuantity,
      );

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        id: json["_id"],
        type: json["type"],
        value: json["value"],
        startDate: json["startDate"] != null
            ? DateTime.parse(json["startDate"])
            : null,
        endDate:
            json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
        minQuantity: json["minQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "value": value,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "minQuantity": minQuantity,
      };
}

class Points {
  int? earnPoints;
  int? redeemPoints;

  Points({
    this.earnPoints,
    this.redeemPoints,
  });

  Points copyWith({
    int? earnPoints,
    int? redeemPoints,
  }) =>
      Points(
        earnPoints: earnPoints ?? this.earnPoints,
        redeemPoints: redeemPoints ?? this.redeemPoints,
      );

  factory Points.fromJson(Map<String, dynamic> json) => Points(
        earnPoints: json["earnPoints"],
        redeemPoints: json["redeemPoints"],
      );

  Map<String, dynamic> toJson() => {
        "earnPoints": earnPoints,
        "redeemPoints": redeemPoints,
      };
}

class Pricing {
  Profit? profit;
  int? costPrice;
  int? salePrice;
  int? commission;
  int? wholesaleCommission;
  int? specialClientCommission;

  Pricing({
    this.profit,
    this.costPrice,
    this.salePrice,
    this.commission,
    this.wholesaleCommission,
    this.specialClientCommission,
  });

  Pricing copyWith({
    Profit? profit,
    int? costPrice,
    int? salePrice,
    int? commission,
    int? wholesaleCommission,
    int? specialClientCommission,
  }) =>
      Pricing(
        profit: profit ?? this.profit,
        costPrice: costPrice ?? this.costPrice,
        salePrice: salePrice ?? this.salePrice,
        commission: commission ?? this.commission,
        wholesaleCommission: wholesaleCommission ?? this.wholesaleCommission,
        specialClientCommission:
            specialClientCommission ?? this.specialClientCommission,
      );

  factory Pricing.fromJson(Map<String, dynamic> json) => Pricing(
        profit: json["profit"] != null ? Profit.fromJson(json["profit"]) : null,
        costPrice: json["costPrice"],
        salePrice: json["salePrice"],
        commission: json["commission"],
        wholesaleCommission: json["wholesaleCommission"],
        specialClientCommission: json["specialClientCommission"],
      );

  Map<String, dynamic> toJson() => {
        "profit": profit?.toJson(),
        "costPrice": costPrice,
        "salePrice": salePrice,
        "commission": commission,
        "wholesaleCommission": wholesaleCommission,
        "specialClientCommission": specialClientCommission,
      };
}

class Profit {
  int? amount;
  double? percentage;

  Profit({
    this.amount,
    this.percentage,
  });

  Profit copyWith({
    int? amount,
    double? percentage,
  }) =>
      Profit(
        amount: amount ?? this.amount,
        percentage: percentage ?? this.percentage,
      );

  factory Profit.fromJson(Map<String, dynamic> json) => Profit(
        amount: json["amount"],
        percentage: json["percentage"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "percentage": percentage,
      };
}

class SimpleProduct {
  Pricing? pricing;
  Points? points;
  int? stock;
  int? quantity;
  String? barcode;

  SimpleProduct({
    this.pricing,
    this.points,
    this.stock,
    this.quantity,
    this.barcode,
  });

  SimpleProduct copyWith({
    Pricing? pricing,
    Points? points,
    int? stock,
    int? quantity,
    String? barcode,
  }) =>
      SimpleProduct(
        pricing: pricing ?? this.pricing,
        points: points ?? this.points,
        stock: stock ?? this.stock,
        quantity: quantity ?? this.quantity,
        barcode: barcode ?? this.barcode,
      );

  factory SimpleProduct.fromJson(Map<String, dynamic> json) => SimpleProduct(
        pricing: Pricing.fromJson(json["pricing"]),
        points: Points.fromJson(json["points"]),
        stock: json["stock"],
        quantity: json["quantity"],
        barcode: json["barcode"],
      );

  Map<String, dynamic> toJson() => {
        "pricing": pricing?.toJson(),
        "points": points?.toJson(),
        "stock": stock,
        "quantity": quantity,
        "barcode": barcode,
      };
}

class Variant {
  String? id;
  String? sku;
  Colores? color;
  dynamic size;
  Measurements? measurements;
  Pricing? pricing;
  Points? points;
  int? stock;
  List<dynamic>? images;
  dynamic barcode;
  bool? available;

  Variant({
    this.id,
    this.sku,
    this.color,
    this.size,
    this.measurements,
    this.pricing,
    this.points,
    this.stock,
    this.images,
    this.barcode,
    this.available,
  });

  Variant copyWith({
    String? id,
    String? sku,
    Colores? color,
    dynamic size,
    Measurements? measurements,
    Pricing? pricing,
    Points? points,
    int? stock,
    List<dynamic>? images,
    dynamic barcode,
    bool? available,
  }) =>
      Variant(
        id: id ?? this.id,
        sku: sku ?? this.sku,
        color: color ?? this.color,
        size: size ?? this.size,
        measurements: measurements ?? this.measurements,
        pricing: pricing ?? this.pricing,
        points: points ?? this.points,
        stock: stock ?? this.stock,
        images: images ?? this.images,
        barcode: barcode ?? this.barcode,
        available: available ?? this.available,
      );

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json["_id"],
      sku: json["sku"],
      color: json["color"] != null ? Colores.fromJson(json["color"]) : null,
      size: json["size"],
      measurements: json["measurements"] != null
          ? Measurements.fromJson(json["measurements"])
          : null,
      pricing:
          json["pricing"] != null ? Pricing.fromJson(json["pricing"]) : null,
      points: json["points"] != null ? Points.fromJson(json["points"]) : null,
      stock: json["stock"],
      images: json["images"] != null
          ? List<dynamic>.from(json["images"].map((x) => x))
          : null,
      barcode: json["barcode"],
      available: json["available"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sku": sku,
        "color": color?.toJson(),
        "size": size,
        "measurements": measurements?.toJson(),
        "pricing": pricing?.toJson(),
        "points": points?.toJson(),
        "stock": stock,
        "images":
            images != null ? List<dynamic>.from(images!.map((x) => x)) : null,
        "barcode": barcode,
        "available": available,
      };
}

class Colores {
  String? name;
  String? code;

  Colores({
    this.name,
    this.code,
  });

  Colores copyWith({
    String? name,
    String? code,
  }) =>
      Colores(
        name: name ?? this.name,
        code: code ?? this.code,
      );

  factory Colores.fromJson(Map<String, dynamic> json) => Colores(
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
      };
}

class Measurements {
  List<dynamic>? custom;

  Measurements({
    this.custom,
  });

  Measurements copyWith({
    List<dynamic>? custom,
  }) =>
      Measurements(
        custom: custom ?? this.custom,
      );

  factory Measurements.fromJson(Map<String, dynamic> json) => Measurements(
        custom: List<dynamic>.from(json["custom"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "custom": List<dynamic>.from(custom!.map((x) => x)),
      };
}

class Warranty {
  bool? hasWarranty;
  Durations? duration;
  String? type;
  List<String>? coverage;
  List<String>? exclusions;
  Contact? contact;

  Warranty({
    this.hasWarranty,
    this.duration,
    this.type,
    this.coverage,
    this.exclusions,
    this.contact,
  });

  Warranty copyWith({
    bool? hasWarranty,
    Durations? duration,
    String? type,
    List<String>? coverage,
    List<String>? exclusions,
    Contact? contact,
  }) =>
      Warranty(
        hasWarranty: hasWarranty ?? this.hasWarranty,
        duration: duration ?? this.duration,
        type: type ?? this.type,
        coverage: coverage ?? this.coverage,
        exclusions: exclusions ?? this.exclusions,
        contact: contact ?? this.contact,
      );

  factory Warranty.fromJson(Map<String, dynamic> json) => Warranty(
        hasWarranty: json["hasWarranty"],
        duration: Durations.fromJson(json["duration"]),
        type: json["type"],
        coverage: List<String>.from(json["coverage"].map((x) => x)),
        exclusions: List<String>.from(json["exclusions"].map((x) => x)),
        contact:
            json["contact"] == null ? null : Contact.fromJson(json["contact"]),
      );

  Map<String, dynamic> toJson() => {
        "hasWarranty": hasWarranty,
        "duration": duration?.toJson(),
        "type": type,
        "coverage": List<dynamic>.from(coverage!.map((x) => x)),
        "exclusions": List<dynamic>.from(exclusions!.map((x) => x)),
        "contact": contact?.toJson(),
      };
}

class Contact {
  String? phone;
  String? email;

  Contact({
    this.phone,
    this.email,
  });

  Contact copyWith({
    String? phone,
    String? email,
  }) =>
      Contact(
        phone: phone ?? this.phone,
        email: email ?? this.email,
      );

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        phone: json["phone"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "email": email,
      };
}

class Durations {
  int? value;
  String? unit;

  Durations({
    this.value,
    this.unit,
  });

  Durations copyWith({
    int? value,
    String? unit,
  }) =>
      Durations(
        value: value ?? this.value,
        unit: unit ?? this.unit,
      );

  factory Durations.fromJson(Map<String, dynamic> json) => Durations(
        value: json["value"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "unit": unit,
      };
}

class Pagination {
  int? limit;
  int? from;
  bool? hasMore;

  Pagination({
    this.limit,
    this.from,
    this.hasMore,
  });

  Pagination copyWith({
    int? limit,
    int? from,
    bool? hasMore,
  }) =>
      Pagination(
        limit: limit ?? this.limit,
        from: from ?? this.from,
        hasMore: hasMore ?? this.hasMore,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        limit: json["limit"],
        from: json["from"],
        hasMore: json["hasMore"],
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "from": from,
        "hasMore": hasMore,
      };
}
