// ignore_for_file: public_member_api_docs, use_build_context_synchronously

import 'dart:async';

import 'package:api_helper/api_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

/// {@template app_bloc}
/// The `AppBloc` class is a Dart class that represents the business logic
/// for the main application.
///
/// This class is responsible for handling all of the business logic for the
/// main application. This includes handling the app's state, reacting to
/// events from the UI, and performing any logic to determine what the UI
/// should display.
/// {@endtemplate}
class AppBloc extends Bloc<AppEvent, AppState> {
  /// {@macro app_bloc}
  AppBloc() : super(AppState()) {
    on<GetUserData>(_getUser);
    on<SetUserData>(_setUserData);
    on<SetSelectedInte>(_setSelectedInte);
    on<OnClearSessionEvent>(_onClearSession);
    on<ChangeEnvEvent>(_onChangeEnv);
    on<ChangeVisibilityModalsEvent>(_onChangeVisibilityModals);
    on<SetSessionFamilyInteList>(_setSessionFamilyInteList);
  }

  FutureOr<void> _setUserData(SetUserData event, Emitter<AppState> emit) {
    emit(
      state.copyWith(
        token: event.token,
        userName: event.userName,
        userSession: event.userSession,
        signIn: false,
      ),
    );
  }

  FutureOr<void> _getUser(GetUserData event, Emitter<AppState> emit) async {}

  void _setSelectedInte(SetSelectedInte event, Emitter<AppState> emit) {
    emit(state.copyWith(selectedInstitution: event.selectedInstitution));
  }

  void _setSessionFamilyInteList(SetSessionFamilyInteList event, Emitter<AppState> emit) {
    emit(
      state.copyWith(),
    );
  }

  Future<void> _onClearSession(OnClearSessionEvent event, Emitter<AppState> emit) async {
    emit(const AppState());
    // env: state.env,
    // firstBiometric: false,
  }

  void _onChangeEnv(ChangeEnvEvent event, Emitter<AppState> emit) {
    emit(
      AppState(),
    );
  }

  void _onChangeVisibilityModals(ChangeVisibilityModalsEvent event, Emitter<AppState> emit) {
    emit(
      state.copyWith(
        legalNotificationModal: event.legalNotificationModal,
      ),
    );
  }
}
