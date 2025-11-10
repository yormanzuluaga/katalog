class LoginException implements Exception {
  LoginException({required this.message});
  final String message;
}

class RegisterException implements Exception {
  RegisterException({required this.message});
  final String message;
}

class GeneralException implements Exception {
  GeneralException(this.msg);
  final String msg;

  @override
  String toString() => msg;
}

class VerificationException implements Exception {
  VerificationException({required this.message});
  final String message;
}

class ExpensesDataException implements Exception {
  ExpensesDataException({required this.message});
  final String message;
}

class SalesDataException implements Exception {
  SalesDataException({required this.message});
  final String message;
}

class SalesException implements Exception {
  SalesException({required this.message});
  final String message;
}

class ExpensesException implements Exception {
  ExpensesException({required this.message});
  final String message;
}

class StartingException implements Exception {
  StartingException({required this.message});
  final String message;
}

class SaveUserException implements Exception {
  SaveUserException({required this.message});
  final String message;
}

class NewUserException implements Exception {
  NewUserException({required this.message});
  final String message;
}

class CountryNotAvailableException implements Exception {
  CountryNotAvailableException({required this.message});
  final String message;
}

class ReferralCodeException implements Exception {
  ReferralCodeException({required this.message});
  final String message;
}
