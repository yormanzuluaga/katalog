import 'package:api_helper/api_helper.dart';

abstract class AddressRepository {
  Future<(ApiException?, AddressModel?)> getAddress({
    Map<String, String>? headers,
  });

  Future<(ApiException?, bool?)> postAddress({
    required AddressUserModel address,
    Map<String, String>? headers,
  });

  Future<(ApiException?, AddressModel?)> updateAddress({
    required String idAddress,
    required AddressUserModel address,
    Map<String, String>? headers,
  });

  Future<(ApiException?, AddressModel?)> deleteAddress({
    required String idAddress,
    Map<String, String>? headers,
  });
}
