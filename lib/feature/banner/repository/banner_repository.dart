import 'package:api_helper/api_helper.dart';

abstract class BannerRepository {
  Future<BannerResponse> getBanners();
}

class BannerRepositoryImpl implements BannerRepository {
  BannerRepositoryImpl({required BannerResource bannerResource})
      : _bannerResource = bannerResource;

  final BannerResource _bannerResource;

  @override
  Future<BannerResponse> getBanners() async {
    final (error, response) = await _bannerResource.getBanners(null);

    if (error != null) {
      throw Exception('Error al cargar banners: ${error.message}');
    }

    if (response == null) {
      throw Exception('No se recibió respuesta del servidor');
    }

    return response;
  }
}
