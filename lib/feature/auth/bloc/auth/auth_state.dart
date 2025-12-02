part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final String? message;
  final String? indexScreen;
  final String? numberPhone;
  final String? code;

  const AuthState({
    this.message,
    this.indexScreen = 'login',
    this.numberPhone,
    this.code,
  });

  AuthState copyWith({
    String? message,
    String? indexScreen,
    String? numberPhone,
    String? code,
  }) {
    return AuthState(
      message: message ?? this.message,
      indexScreen: indexScreen ?? this.indexScreen,
      numberPhone: numberPhone ?? this.numberPhone,
      code: code ?? this.code,
    );
  }

  @override
  List<Object?> get props => [
        message,
        indexScreen,
        numberPhone,
        code,
        indexScreen,
      ];
}
