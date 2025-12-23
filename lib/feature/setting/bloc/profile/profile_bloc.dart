import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/core/database/user_store.dart';
import 'package:api_repository/api_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const ProfileState()) {
    on<UpdateProfile>(_onUpdateProfile);
  }

  final UserRepository _userRepository;

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, message: null));

    try {
      final userId = UserStore.instance.uid;

      if (userId.isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          message: 'Error: Usuario no identificado',
        ));
        return;
      }

      final (error, response) = await _userRepository.updateUser(
        userId: userId,
        firstName: event.firstName,
        lastName: event.lastName,
        mobile: event.mobile,
      );

      if (error != null) {
        emit(state.copyWith(
          isLoading: false,
          message: 'Error al actualizar perfil: ${error.message}',
        ));
        return;
      }

      if (response != null && response.success) {
        // Actualizar UserStore con los nuevos datos
        await UserStore.instance.updateUserInfo(
          firstName: event.firstName,
          lastName: event.lastName,
          mobile: event.mobile,
        );

        emit(state.copyWith(
          isLoading: false,
          message: 'Perfil actualizado exitosamente',
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          message: 'Error al actualizar perfil',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        message: 'Error: ${e.toString()}',
      ));
    }
  }
}
