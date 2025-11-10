import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';

class AddressRepositoryImpl extends AddressRepository {
  AddressResource addressResource;
  @override
  AddressRepositoryImpl({
    required this.addressResource,
  });

  @override
  Future<(ApiException?, AddressModel?)> getAddress({
    Map<String, String>? headers,
  }) async {
    final addressModel = await addressResource.getAddress(
      headers: headers,
    );
    final leftResponse = addressModel.$1;
    final rightResponse = addressModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, bool?)> postAddress({
    required AddressUserModel address,
    Map<String, String>? headers,
  }) async {
    final addressModel = await addressResource.postAddress(
      address: address,
      headers: headers,
    );

    final leftResponse = addressModel.$1;
    final rightResponse = addressModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, AddressModel?)> updateAddress({
    required String idAddress,
    required AddressUserModel address,
    Map<String, String>? headers,
  }) async {
    final addressModel = await addressResource.updateAddress(
      idAddress: idAddress,
      address: address,
      headers: headers,
    );

    final leftResponse = addressModel.$1;
    final rightResponse = addressModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }

  @override
  Future<(ApiException?, AddressModel?)> deleteAddress({
    required String idAddress,
    Map<String, String>? headers,
  }) async {
    final addressModel = await addressResource.deleteAddress(
      idAddress: idAddress,
      headers: headers,
    );

    final leftResponse = addressModel.$1;
    final rightResponse = addressModel.$2;
    if (leftResponse != null || rightResponse == null) {
      return Future.value((leftResponse, null));
    }
    return Future.value((null, rightResponse));
  }
}
