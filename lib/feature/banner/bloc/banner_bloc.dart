import 'package:api_helper/api_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/banner/repository/banner_repository.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc({required BannerRepository bannerRepository})
      : _bannerRepository = bannerRepository,
        super(const BannerState()) {
    on<LoadBanners>(_onLoadBanners);
  }

  final BannerRepository _bannerRepository;

  Future<void> _onLoadBanners(
    LoadBanners event,
    Emitter<BannerState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, message: null));

    try {
      final response = await _bannerRepository.getBanners();

      if (response.success && response.banners.isNotEmpty) {
        // Filter only active banners and sort by position
        final activeBanners = response.banners
            .where((banner) => banner.isActive)
            .toList()
          ..sort((a, b) => a.position.compareTo(b.position));

        emit(state.copyWith(
          banners: activeBanners,
          isLoading: false,
          message: null,
        ));
      } else {
        emit(state.copyWith(
          banners: [],
          isLoading: false,
          message: 'No hay banners disponibles',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        message: 'Error al cargar banners: ${e.toString()}',
      ));
    }
  }
}
