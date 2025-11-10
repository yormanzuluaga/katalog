import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/app/routes/router_config.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc({
    required AddressRepository addressRepository,
  })  : _addressRepository = addressRepository,
        super(AddressState()) {
    on<AddressEvent>((event, emit) {});

    on<LoadAddresses>((event, emit) async {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

      emit(state.copyWith(isLoading: true));
      final response = await _addressRepository.getAddress(
        headers: appState.createHeaders(),
      );
      final apiException = response.$1;
      final addressModel = response.$2;
      if (apiException != null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Error al cargar las direcciones',
        ));
      } else {
        emit(state.copyWith(
          addressModel: addressModel!,
          isLoading: false,
        ));
      }
    });

    on<CreateAddress>((event, emit) async {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

      emit(state.copyWith(isLoading: true));
      final response = await _addressRepository.postAddress(
        address: event.address,
        headers: appState.createHeaders(),
      );
      final apiException = response.$1;
      final addressModel = response.$2;
      if (apiException != null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Error al crear la dirección',
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
        ));
      }
    });

    on<UpdateAddress>((event, emit) async {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

      emit(state.copyWith(isLoading: true));
      final response = await _addressRepository.updateAddress(
        idAddress: event.id,
        address: event.address,
        headers: appState.createHeaders(),
      );
      final apiException = response.$1;
      final addressModel = response.$2;
      if (apiException != null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Error al actualizar la dirección',
        ));
      } else {
        emit(state.copyWith(
          addressModel: addressModel!,
          isLoading: false,
        ));
      }
    });

    on<DeleteAddress>((event, emit) async {
      final appState = rootNavigatorKey.currentContext!.read<AppBloc>().state;

      emit(state.copyWith(isLoading: true));
      final response = await _addressRepository.deleteAddress(
        idAddress: event.id,
        headers: appState.createHeaders(),
      );
      final apiException = response.$1;
      final addressModel = response.$2;
      if (apiException != null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Error al eliminar la dirección',
        ));
      } else {
        emit(state.copyWith(
          addressModel: addressModel!,
          isLoading: false,
        ));
      }
    });

    on<SelectAddress>((event, emit) async {
      emit(state.copyWith(selectedAddress: event.address));
    });
  }

  final AddressRepository _addressRepository;
}
