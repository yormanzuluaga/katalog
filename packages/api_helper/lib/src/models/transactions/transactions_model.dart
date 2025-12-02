import 'package:equatable/equatable.dart';

/// {@template payment_transaction_model}
/// Model for payment transaction data
/// {@endtemplate}
class PaymentTransactionModel extends Equatable {
  /// {@macro payment_transaction_model}
  const PaymentTransactionModel({
    required this.items,
    required this.shippingAddressId,
    required this.wompiTransactionId,
    required this.wompiReference,
    required this.paymentStatus,
    required this.customerEmail,
    this.approvalCode = '321',
  });

  /// Creates a [PaymentTransactionModel] from a JSON object
  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) {
    return PaymentTransactionModel(
      items:
          (json['items'] as List<dynamic>?)?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>)).toList() ??
              [],
      shippingAddressId: json['shippingAddressId'] as String? ?? '',
      wompiTransactionId: json['wompiTransactionId'] as String? ?? '',
      wompiReference: json['wompiReference'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      customerEmail: json['customerEmail'] as String? ?? '',
      approvalCode: json['approvalCode'] as String? ?? '',
    );
  }

  /// List of transaction items
  final List<TransactionItem> items;

  /// Shipping address ID
  final String shippingAddressId;

  /// Wompi transaction ID
  final String wompiTransactionId;

  /// Wompi reference
  final String wompiReference;

  /// Payment status (approved, pending, declined, etc.)
  final String paymentStatus;

  /// Customer email
  final String customerEmail;

  /// Approval code
  final String approvalCode;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'shippingAddressId': shippingAddressId,
      'wompiTransactionId': wompiTransactionId,
      'wompiReference': wompiReference,
      'paymentStatus': paymentStatus,
      'customerEmail': customerEmail,
      'approvalCode': approvalCode,
    };
  }

  @override
  List<Object?> get props => [
        items,
        shippingAddressId,
        wompiTransactionId,
        wompiReference,
        paymentStatus,
        customerEmail,
        approvalCode,
      ];
}

/// {@template transaction_item}
/// Model for a single item in a transaction
/// {@endtemplate}
class TransactionItem extends Equatable {
  /// {@macro transaction_item}
  const TransactionItem({
    required this.productId,
    required this.productType,
    required this.quantity,
    required this.unitPrice,
    required this.commission,
    this.variations,
  });

  /// Creates a [TransactionItem] from a JSON object
  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      productId: json['productId'] as String? ?? '',
      productType: json['productType'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      commission: (json['commission'] as num?)?.toDouble() ?? 0.0,
      variations: json['variations'] != null
          ? ProductVariations.fromJson(
              json['variations'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Product ID
  final String productId;

  /// Product type (simple, variable, etc.)
  final String productType;

  /// Quantity purchased
  final int quantity;

  /// Unit price
  final double unitPrice;

  /// Commission amount
  final double commission;

  /// Product variations (color, size, etc.)
  final ProductVariations? variations;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productType': productType,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'commission': commission,
      if (variations != null) 'variations': variations!.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        productId,
        productType,
        quantity,
        unitPrice,
        commission,
        variations,
      ];
}

/// {@template product_variations}
/// Model for product variations
/// {@endtemplate}
class ProductVariations extends Equatable {
  /// {@macro product_variations}
  const ProductVariations({
    this.color,
    this.size,
    this.material,
    this.customOptions,
  });

  /// Creates a [ProductVariations] from a JSON object
  factory ProductVariations.fromJson(Map<String, dynamic> json) {
    return ProductVariations(
      color: json['color'] != null ? ColorVariation.fromJson(json['color'] as Map<String, dynamic>) : null,
      size: json['size'] != null ? SizeVariation.fromJson(json['size'] as Map<String, dynamic>) : null,
      material: json['material'] != null ? MaterialVariation.fromJson(json['material'] as Map<String, dynamic>) : null,
      customOptions: (json['customOptions'] as List<dynamic>?)
          ?.map((e) => CustomOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Color variation
  final ColorVariation? color;

  /// Size variation
  final SizeVariation? size;

  /// Material variation
  final MaterialVariation? material;

  /// Custom options
  final List<CustomOption>? customOptions;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      if (color != null) 'color': color!.toJson(),
      if (size != null) 'size': size!.toJson(),
      if (material != null) 'material': material!.toJson(),
      if (customOptions != null) 'customOptions': customOptions!.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [color, size, material, customOptions];
}

/// {@template color_variation}
/// Model for color variation
/// {@endtemplate}
class ColorVariation extends Equatable {
  /// {@macro color_variation}
  const ColorVariation({
    required this.name,
    required this.code,
    this.image,
  });

  /// Creates a [ColorVariation] from a JSON object
  factory ColorVariation.fromJson(Map<String, dynamic> json) {
    return ColorVariation(
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      image: json['image'] as String?,
    );
  }

  /// Color name
  final String name;

  /// Color code (hex)
  final String code;

  /// Color image URL
  final String? image;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      if (image != null) 'image': image,
    };
  }

  @override
  List<Object?> get props => [name, code, image];
}

/// {@template size_variation}
/// Model for size variation
/// {@endtemplate}
class SizeVariation extends Equatable {
  /// {@macro size_variation}
  const SizeVariation({
    required this.name,
    required this.code,
  });

  /// Creates a [SizeVariation] from a JSON object
  factory SizeVariation.fromJson(Map<String, dynamic> json) {
    return SizeVariation(
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );
  }

  /// Size name
  final String name;

  /// Size code
  final String code;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }

  @override
  List<Object?> get props => [name, code];
}

/// {@template material_variation}
/// Model for material variation
/// {@endtemplate}
class MaterialVariation extends Equatable {
  /// {@macro material_variation}
  const MaterialVariation({
    required this.name,
    required this.code,
  });

  /// Creates a [MaterialVariation] from a JSON object
  factory MaterialVariation.fromJson(Map<String, dynamic> json) {
    return MaterialVariation(
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );
  }

  /// Material name
  final String name;

  /// Material code
  final String code;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }

  @override
  List<Object?> get props => [name, code];
}

/// {@template custom_option}
/// Model for custom option
/// {@endtemplate}
class CustomOption extends Equatable {
  /// {@macro custom_option}
  const CustomOption({
    required this.optionName,
    required this.optionValue,
    this.additionalCost,
  });

  /// Creates a [CustomOption] from a JSON object
  factory CustomOption.fromJson(Map<String, dynamic> json) {
    return CustomOption(
      optionName: json['optionName'] as String? ?? '',
      optionValue: json['optionValue'] as String? ?? '',
      additionalCost: (json['additionalCost'] as num?)?.toDouble(),
    );
  }

  /// Option name
  final String optionName;

  /// Option value
  final String optionValue;

  /// Additional cost for this option
  final double? additionalCost;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'optionName': optionName,
      'optionValue': optionValue,
      if (additionalCost != null) 'additionalCost': additionalCost,
    };
  }

  @override
  List<Object?> get props => [optionName, optionValue, additionalCost];
}

/// {@template transaction_response}
/// Model for transaction response from API
/// {@endtemplate}
class TransactionResponse extends Equatable {
  /// {@macro transaction_response}
  const TransactionResponse({
    this.success,
    this.message,
    this.transactionId,
    this.data,
  });

  /// Creates a [TransactionResponse] from a JSON object
  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      transactionId: json['transactionId'] as String?,
      data: json['data'] != null ? PaymentTransactionModel.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }

  /// Whether the transaction was successful
  final bool? success;

  /// Response message
  final String? message;

  /// Transaction ID from the server
  final String? transactionId;

  /// Transaction data
  final PaymentTransactionModel? data;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      if (success != null) 'success': success,
      if (message != null) 'message': message,
      if (transactionId != null) 'transactionId': transactionId,
      if (data != null) 'data': data!.toJson(),
    };
  }

  @override
  List<Object?> get props => [success, message, transactionId, data];
}
