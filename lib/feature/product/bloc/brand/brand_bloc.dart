import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/app/routes/router_config.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository _brandRepository;

  BrandBloc({required BrandRepository brandRepository})
      : _brandRepository = brandRepository,
        super(const BrandState()) {
    on<LoadBrands>(_onLoadBrands);
    on<LoadProductsByBrand>(_onLoadProductsByBrand);
  }

  Future<void> _onLoadBrands(
    LoadBrands event,
    Emitter<BrandState> emit,
  ) async {
    emit(state.copyWith(message: null));

    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _brandRepository.getBrands(
      headers: appState.createHeaders(),
    );

    if (result.$1 != null) {
      emit(state.copyWith(message: result.$1!.message));
      return;
    }

    if (result.$2 != null) {
      emit(state.copyWith(
        brandId: null,
        brandName: null,
        brands: result.$2!.brands,
      ));
    } else {
      emit(state.copyWith(message: 'No se pudieron cargar las marcas'));
    }
  }

  Future<void> _onLoadProductsByBrand(
    LoadProductsByBrand event,
    Emitter<BrandState> emit,
  ) async {
    final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

    final result = await _brandRepository.getProductsByBrand(
      brandId: event.brandId,
      headers: appState.createHeaders(),
    );
    final leftResponse = result.$1;
    final rightResponse = result.$2;
    if (leftResponse != null || rightResponse == null) {
      emit(state.copyWith(message: result.$1!.message));
      return;
    } else {
      emit(state.copyWith(
        products: result.$2!.products,
      ));
    }
  }
}
