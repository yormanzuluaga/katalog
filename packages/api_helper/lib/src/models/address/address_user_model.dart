import 'package:api_helper/api_helper.dart';

class AddressUserModel {
  String title;
  String fullName;
  String phone;
  String address;
  String city;
  String state;
  String country;
  String? postalCode;
  String? neighborhood;
  String? instructions;
  bool? isDefault;
  Coordinates? coordinates;

  AddressUserModel({
    required this.title,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    this.postalCode,
    this.neighborhood,
    this.instructions,
    this.isDefault,
    this.coordinates,
  });

  AddressUserModel copyWith({
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
  }) =>
      AddressUserModel(
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
      );

  factory AddressUserModel.fromJson(Map<String, dynamic> json) => AddressUserModel(
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
        coordinates: Coordinates.fromJson(json["coordinates"]),
      );

  Map<String, dynamic> toJson() => {
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
      };
}
