import 'package:equatable/equatable.dart';

/// {@template shipping_orders_response}
/// Model for shipping orders API response
/// {@endtemplate}
class ShippingOrdersResponse extends Equatable {
  /// {@macro shipping_orders_response}
  const ShippingOrdersResponse({
    required this.success,
    required this.total,
    required this.orders,
    required this.hasMore,
  });

  /// Creates a [ShippingOrdersResponse] from a JSON object
  factory ShippingOrdersResponse.fromJson(Map<String, dynamic> json) {
    return ShippingOrdersResponse(
      success: json['success'] as bool? ?? false,
      total: json['total'] as int? ?? 0,
      orders: (json['orders'] as List<dynamic>?)
              ?.map((e) => ShippingOrder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }

  /// Whether the request was successful
  final bool success;

  /// Total number of orders
  final int total;

  /// List of orders
  final List<ShippingOrder> orders;

  /// Whether there are more orders to load
  final bool hasMore;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'total': total,
      'orders': orders.map((e) => e.toJson()).toList(),
      'hasMore': hasMore,
    };
  }

  @override
  List<Object?> get props => [success, total, orders, hasMore];
}

/// {@template shipping_order}
/// Model for a shipping order
/// {@endtemplate}
class ShippingOrder extends Equatable {
  /// {@macro shipping_order}
  const ShippingOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.commission,
    required this.tracking,
    required this.createdAt,
  });

  /// Creates a [ShippingOrder] from a JSON object
  factory ShippingOrder.fromJson(Map<String, dynamic> json) {
    return ShippingOrder(
      id: json['_id'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      status: json['status'] as String? ?? '',
      statusLabel: json['statusLabel'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      shippingAddress: json['shippingAddress'] != null
          ? ShippingAddress.fromJson(
              json['shippingAddress'] as Map<String, dynamic>)
          : const ShippingAddress(
              title: '',
              fullName: '',
              phone: '',
              address: '',
              city: '',
              state: '',
              country: '',
              postalCode: '',
            ),
      commission: json['commission'] != null
          ? Commission.fromJson(json['commission'] as Map<String, dynamic>)
          : const Commission(amount: 0, points: 0, status: ''),
      tracking: json['tracking'] != null
          ? Tracking.fromJson(json['tracking'] as Map<String, dynamic>)
          : const Tracking(),
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  /// Order ID
  final String id;

  /// Order number
  final String orderNumber;

  /// Order status
  final String status;

  /// Order status label
  final String statusLabel;

  /// List of items in the order
  final List<OrderItem> items;

  /// Total amount
  final double totalAmount;

  /// Shipping address
  final ShippingAddress shippingAddress;

  /// Commission information
  final Commission commission;

  /// Tracking information
  final Tracking tracking;

  /// Creation date
  final String createdAt;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'orderNumber': orderNumber,
      'status': status,
      'statusLabel': statusLabel,
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress.toJson(),
      'commission': commission.toJson(),
      'tracking': tracking.toJson(),
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        status,
        statusLabel,
        items,
        totalAmount,
        shippingAddress,
        commission,
        tracking,
        createdAt,
      ];
}

/// {@template order_item}
/// Model for an order item
/// {@endtemplate}
class OrderItem extends Equatable {
  /// {@macro order_item}
  const OrderItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.image,
  });

  /// Creates a [OrderItem] from a JSON object
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] as String?,
    );
  }

  /// Item name
  final String name;

  /// Quantity
  final int quantity;

  /// Unit price
  final double unitPrice;

  /// Total price
  final double totalPrice;

  /// Image URL
  final String? image;

  /// Converts the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      if (image != null) 'image': image,
    };
  }

  @override
  List<Object?> get props => [name, quantity, unitPrice, totalPrice, image];
}

/// {@template shipping_address}
/// Model for shipping address
/// {@endtemplate}
class ShippingAddress extends Equatable {
  /// {@macro shipping_address}
  const ShippingAddress({
    required this.title,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.coordinates,
    this.neighborhood,
    this.instructions,
    this.isDefault,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.uid,
  });

  /// Creates a [ShippingAddress] from a JSON object
  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      title: json['title'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      coordinates: json['coordinates'] != null
          ? ShippingCoordinates.fromJson(
              json['coordinates'] as Map<String, dynamic>)
          : null,
      neighborhood: json['neighborhood'] as String?,
      instructions: json['instructions'] as String?,
      isDefault: json['isDefault'] as bool?,
      user: json['user'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      uid: json['uid'] as String?,
    );
  }

  final String title;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final ShippingCoordinates? coordinates;
  final String? neighborhood;
  final String? instructions;
  final bool? isDefault;
  final String? user;
  final String? createdAt;
  final String? updatedAt;
  final String? uid;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      if (coordinates != null) 'coordinates': coordinates!.toJson(),
      if (neighborhood != null) 'neighborhood': neighborhood,
      if (instructions != null) 'instructions': instructions,
      if (isDefault != null) 'isDefault': isDefault,
      if (user != null) 'user': user,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (uid != null) 'uid': uid,
    };
  }

  @override
  List<Object?> get props => [
        title,
        fullName,
        phone,
        address,
        city,
        state,
        country,
        postalCode,
        coordinates,
        neighborhood,
        instructions,
        isDefault,
        user,
        createdAt,
        updatedAt,
        uid,
      ];
}

/// {@template shipping_coordinates}
/// Model for geographic coordinates
/// {@endtemplate}
class ShippingCoordinates extends Equatable {
  /// {@macro shipping_coordinates}
  const ShippingCoordinates({
    required this.latitude,
    required this.longitude,
  });

  /// Creates a [ShippingCoordinates] from a JSON object
  factory ShippingCoordinates.fromJson(Map<String, dynamic> json) {
    return ShippingCoordinates(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object?> get props => [latitude, longitude];
}

/// {@template commission}
/// Model for commission information
/// {@endtemplate}
class Commission extends Equatable {
  /// {@macro commission}
  const Commission({
    required this.amount,
    required this.points,
    required this.status,
  });

  /// Creates a [Commission] from a JSON object
  factory Commission.fromJson(Map<String, dynamic> json) {
    return Commission(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      points: json['points'] as int? ?? 0,
      status: json['status'] as String? ?? '',
    );
  }

  final double amount;
  final int points;
  final String status;

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'points': points,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [amount, points, status];
}

/// {@template tracking}
/// Model for tracking information
/// {@endtemplate}
class Tracking extends Equatable {
  /// {@macro tracking}
  const Tracking({
    this.estimatedDelivery,
  });

  /// Creates a [Tracking] from a JSON object
  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      estimatedDelivery: json['estimatedDelivery'] as String?,
    );
  }

  final String? estimatedDelivery;

  Map<String, dynamic> toJson() {
    return {
      if (estimatedDelivery != null) 'estimatedDelivery': estimatedDelivery,
    };
  }

  @override
  List<Object?> get props => [estimatedDelivery];
}
