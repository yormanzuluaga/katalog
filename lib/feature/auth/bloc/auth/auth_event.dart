part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthMobileEvent extends AuthEvent {
  final String mobile;
  final String otp;
  final BuildContext context;

  const AuthMobileEvent({
    required this.mobile,
    required this.context,
    required this.otp,
  });
}

class VerificationEvent extends AuthEvent {
  final String mobile;
  final String code;

  final BuildContext context;

  const VerificationEvent({
    required this.mobile,
    required this.code,
    required this.context,
  });

  @override
  List<Object> get props => [mobile, code, context];
}

class VerificationCodeEvent extends AuthEvent {
  final String code;

  final BuildContext context;

  const VerificationCodeEvent({
    required this.code,
    required this.context,
  });

  @override
  List<Object> get props => [code, context];
}

class AuthInforEvent extends AuthEvent {
  final String indexScreen;

  const AuthInforEvent({
    required this.indexScreen,
  });

  @override
  List<Object> get props => [indexScreen];
}
