import 'dart:convert';

import 'package:api_repository/api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/bloc/app_bloc.dart';
import 'package:talentpitch_test/app/routes/router_config.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/core/database/login_store.dart';
import 'package:talentpitch_test/core/database/user_store.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthState()) {
    on<AuthEvent>((event, emit) {});

    on<AuthMobileEvent>((event, emit) async {});
    on<VerificationEvent>((event, emit) async {
      final result = await _authRepository.getVerification(
        mobile: event.mobile,
        code: event.code,
      );
      final leftResponse = result.$1;
      final rightResponse = result.$2;
      if (leftResponse != null || rightResponse == null) {
        String message = leftResponse!.message;
        emit(state.copyWith(message: message));
      } else {
        emit(
          state.copyWith(
            indexScreen: 'verify',
            numberPhone: '+${event.code}${event.mobile}',
          ),
        );
      }
    });
    on<VerificationCodeEvent>((event, emit) async {
      final result = await _authRepository.getVerificationCode(
        mobile: state.numberPhone.toString(),
        code: event.code,
      );

      // result.fold(
      //   (l) {
      //     String message = l.message;
      //     emit(state.copyWith(message: message));
      //   },
      //   (r) async {

      //   },
      // );
    });

    on<AuthInforEvent>((event, emit) async {
      emit(state.copyWith(indexScreen: event.indexScreen));
    });
  }

  ///Login method
  Future<void> login(
    BuildContext contextLogin, {
    required String code,
    required Future<void> Function(AppState) onSuccess,
  }) async {
    final result = await _authRepository.getVerificationCode(
      mobile: state.numberPhone.toString(),
      code: code,
    );
    final leftResponse = result.$1;
    final rightResponse = result.$2;
    if (leftResponse != null || rightResponse == null) {
      await LoginStore.instance.removerAccessToken();
      await LoginStore.instance.removeDataPendingJoinTeam();
      await UserStore.instance.outUser();
      await UserStore.instance.outUser();
      print(leftResponse!.message);
      (leftResponse.message == 'Ese numero no esta registrado')
          ? emit(state.copyWith(indexScreen: 'register'))
          : showAppModal<void>(
              context: rootNavigatorKey.currentContext!,
              builder: (context) => AppModal.oneButton(
                title: 'Algunos datos son erróneos',
                subTitle:
                    'Por favor, verificá los campos ingresados para intentar nuevamente.',
                onPressedPrymary: () {
                  Navigator.pop(context);
                },
                buttonTitle: 'Aceptar',
              ),
            );
    } else {
      await LoginStore.instance.logInSession(
        currentStore: 0,
        accessToken: rightResponse.token.toString(),
        refreshToken: rightResponse.token.toString(),
      );

      await UserStore.instance.logInSession(
        uid: rightResponse.user?.uid ?? '',
        userName: rightResponse.user?.lastName ?? '',
        firstName: rightResponse.user?.firstName ?? '',
        lastName: rightResponse.user?.lastName ?? '',
        email: rightResponse.user?.email ?? '',
        country: rightResponse.user?.countryCode ?? '',
        mobile: rightResponse.user?.mobile ?? '',
        avatar: rightResponse.user?.avatar ?? '',
        collaborator: rightResponse.user?.rol ?? '',
        city: rightResponse.user?.lastName ?? '',
        accessStore: rightResponse.token ?? '',
        createdAt: rightResponse.user?.createdAt.toString() ?? '',
        updatedAt: rightResponse.user?.updatedAt.toString() ?? '',
      );

      await UserStore.instance.setUser(user: jsonEncode(rightResponse.user));
      final appState = AppState(
        token: rightResponse.token,
        userSession: (rightResponse.user),
      );

      await onSuccess(appState);
      //  rootNavigatorKey.currentContext!.read<AppBloc>().add(const signInEvent(signIn: false));
      rootNavigatorKey.currentContext?.go(RoutesNames.home);
    }
  }
}
