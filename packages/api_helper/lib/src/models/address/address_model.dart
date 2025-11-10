class AddressModel {
  int? total;
  List<Address>? addresses;

  AddressModel({
    this.total,
    this.addresses,
  });

  AddressModel copyWith({
    int? total,
    List<Address>? addresses,
  }) =>
      AddressModel(
        total: total ?? this.total,
        addresses: addresses ?? this.addresses,
      );

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        total: json["total"],
        addresses: List<Address>.from(json["addresses"].map((x) => Address?.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
      };
}

class Address {
  String? id;
  String? title;
  String? fullName;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? neighborhood;
  String? instructions;
  bool? isDefault;
  Coordinates? coordinates;
  bool? estado;
  DateTime? createdAt;
  DateTime? updatedAt;

  Address({
    this.id,
    this.title,
    this.fullName,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.neighborhood,
    this.instructions,
    this.isDefault,
    this.coordinates,
    this.estado,
    this.createdAt,
    this.updatedAt,
  });

  Address copyWith({
    String? id,
    String? title,
    String? fullName,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? neighborhood,
    String? instructions,
    bool? isDefault,
    Coordinates? coordinates,
    bool? estado,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Address(
        id: id ?? this.id,
        title: title ?? this.title,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        postalCode: postalCode ?? this.postalCode,
        neighborhood: neighborhood ?? this.neighborhood,
        instructions: instructions ?? this.instructions,
        isDefault: isDefault ?? this.isDefault,
        coordinates: coordinates ?? this.coordinates,
        estado: estado ?? this.estado,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["_id"],
        title: json["title"],
        fullName: json["fullName"],
        phone: json["phone"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postalCode: json["postalCode"],
        neighborhood: json["neighborhood"],
        instructions: json["instructions"],
        isDefault: json["isDefault"],
        coordinates: Coordinates?.fromJson(json["coordinates"]),
        estado: json["estado"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "fullName": fullName,
        "phone": phone,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "postalCode": postalCode,
        "neighborhood": neighborhood,
        "instructions": instructions,
        "isDefault": isDefault,
        "coordinates": coordinates?.toJson(),
        "estado": estado,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({
    this.latitude,
    this.longitude,
  });

  Coordinates copyWith({
    double? latitude,
    double? longitude,
  }) =>
      Coordinates(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
