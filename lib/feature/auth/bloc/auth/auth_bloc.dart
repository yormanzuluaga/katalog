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
  final UserRepository _userRepository;

  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(AuthState()) {
    on<AuthEvent>((event, emit) {});

    on<AuthMobileEvent>((event, emit) async {});
    on<CreateUserEvent>(_onCreateUser);
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
      // ignore: unused_local_variable
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

      // Parse JSON response to check message
      String errorMessage = '';
      try {
        final jsonResponse = jsonDecode(leftResponse!.message);
        errorMessage = jsonResponse['msj'] ?? '';
      } catch (e) {
        errorMessage = leftResponse!.message;
      }

      (errorMessage == 'Ese numero no esta registrado')
          ? add(const AuthInforEvent(indexScreen: 'register'))
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

  /// Create User method
  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    print('Creating user: ${event.firstName} ${event.lastName}'); // Debug

    final result = await _userRepository.createUser(
      firstName: event.firstName,
      lastName: event.lastName,
      mobile: event.mobile,
      countryCode: event.countryCode,
      email: event.email,
    );

    final leftResponse = result.$1;
    final rightResponse = result.$2;

    print(
        'Create user result - Error: $leftResponse, Success: ${rightResponse != null}'); // Debug

    if (leftResponse != null || rightResponse == null) {
      // Error al crear usuario
      String errorMessage = '';
      try {
        final jsonResponse = jsonDecode(leftResponse!.message);
        errorMessage = jsonResponse['msj'] ??
            jsonResponse['message'] ??
            'Error al crear usuario';
      } catch (e) {
        errorMessage = leftResponse!.message;
      }

      print('Error creating user: $errorMessage'); // Debug

      showAppModal<void>(
        context: rootNavigatorKey.currentContext!,
        builder: (context) => AppModal.oneButton(
          title: 'Error al registrarse',
          subTitle: errorMessage,
          onPressedPrymary: () {
            Navigator.pop(context);
          },
          buttonTitle: 'Aceptar',
        ),
      );
    } else {
      // Usuario creado exitosamente
      print('User created successfully, logging in...'); // Debug
      print('Token: ${rightResponse.token}'); // Debug
      print('User data: ${rightResponse.user?.toJson()}'); // Debug

      try {
        await LoginStore.instance.logInSession(
          currentStore: 0,
          accessToken: rightResponse.token.toString(),
          refreshToken: rightResponse.token.toString(),
        );

        await UserStore.instance.logInSession(
          uid: rightResponse.user?.uid ?? '',
          userName: rightResponse.user?.firstName ?? '',
          firstName: rightResponse.user?.firstName ?? '',
          lastName: rightResponse.user?.lastName ?? '',
          email: rightResponse.user?.email ?? '',
          country: rightResponse.user?.countryCode ?? '',
          mobile: rightResponse.user?.mobile ?? '',
          avatar: rightResponse.user?.avatar ?? '',
          collaborator: rightResponse.user?.rol ?? '',
          city: '',
          accessStore: rightResponse.token ?? '',
          createdAt: rightResponse.user?.createdAt.toString() ?? '',
          updatedAt: rightResponse.user?.updatedAt.toString() ?? '',
        );

        // Convertir el user a JSON correctamente
        final userJson = rightResponse.user?.toJson();
        if (userJson != null) {
          await UserStore.instance.setUser(user: jsonEncode(userJson));
        }

        // Actualizar AppBloc con los datos del usuario
        final appState = AppState(
          token: rightResponse.token,
          userSession: rightResponse.user,
        );

        rootNavigatorKey.currentContext?.read<AppBloc>().add(
              SetUserData(
                token: rightResponse.token ?? '',
                userName: rightResponse.user?.firstName ?? '',
                userSession: rightResponse.user,
              ),
            );

        print('Navigating to home...'); // Debug

        // Redirigir a home
        rootNavigatorKey.currentContext?.go(RoutesNames.home);
      } catch (e, stackTrace) {
        print('Error saving user data: $e'); // Debug
        print('StackTrace: $stackTrace'); // Debug

        showAppModal<void>(
          context: rootNavigatorKey.currentContext!,
          builder: (context) => AppModal.oneButton(
            title: 'Error al guardar datos',
            subTitle:
                'Hubo un problema al guardar tus datos. Por favor, intenta iniciar sesión nuevamente.',
            onPressedPrymary: () {
              Navigator.pop(context);
              rootNavigatorKey.currentContext?.go(RoutesNames.login);
            },
            buttonTitle: 'Aceptar',
          ),
        );
      }
    }
  }
}
