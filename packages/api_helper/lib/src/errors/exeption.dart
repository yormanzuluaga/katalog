class LoginException implements Exception {
  final String message;

  LoginException({required this.message});
}

class RegisterException implements Exception {
  final String message;

  RegisterException({required this.message});
}

class GeneralException implements Exception {
  final String msg;

  GeneralException(this.msg);

  @override
  String toString() => msg;
}

class VerificationException implements Exception {
  final String message;

  VerificationException({required this.message});
}

class ExpensesDataException implements Exception {
  final String message;

  ExpensesDataException({required this.message});
}

class SalesDataException implements Exception {
  final String message;

  SalesDataException({required this.message});
}

class SalesException implements Exception {
  final String message;

  SalesException({required this.message});
}

class ExpensesException implements Exception {
  final String message;

  ExpensesException({required this.message});
}

class StartingException implements Exception {
  final String message;

  StartingException({required this.message});
}

class SaveUserException implements Exception {
  final String message;

  SaveUserException({required this.message});
}

class NewUserException implements Exception {
  final String message;

  NewUserException({required this.message});
}

class CountryNotAvailableException implements Exception {
  final String message;

  CountryNotAvailableException({required this.message});
}

class ReferralCodeException implements Exception {
  final String message;

  ReferralCodeException({required this.message});
}
