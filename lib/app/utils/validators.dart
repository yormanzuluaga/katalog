/// Validators class to validate fields like email, phone, etc.
class Validators {
  /// Check if the given string is a valid email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Check if the given string is a valid phone number
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(
      r'^[+]*[(]{0,1}[0-9]{1,5}[)]{0,1}[-\s\.0-9]*$',
    );
    return phoneRegex.hasMatch(phone);
  }

  /// Check if the given string is a valid date
  static bool isValidDate(String date, {String? separator = '/'}) {
    final dateRegex = RegExp(
      '^(0[1-9]|[12][0-9]|3[01])\\$separator(0[1-9]|1[0-2])\\$separator(19|20)\\d{2}\$',
    );

    return dateRegex.hasMatch(date);
  }

  /// Check if the given string is a valid CUIT/CUIL
  static bool isValdCuit(String cuit) {
    final regexp = RegExp(r'^(20|23|27|30|33)([0-9]{9})$');
    final multipliers = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2];
    var result = false;
    if (regexp.hasMatch(cuit)) {
      final validationDigit = int.parse(cuit.substring(cuit.length - 1));
      final prefix = int.parse(cuit.substring(0, 2));
      var sum = 0;
      for (var i = 0; i < multipliers.length; i++) {
        sum += int.parse(cuit[i]) * multipliers[i];
      }
      final remainder = sum % 11;
      if (remainder == 1) {
        return prefix == 23 && [4, 9].contains(validationDigit);
      }
      if (remainder == 0) {
        result = remainder == validationDigit;
      }
      return result;
    }

    return false;
  }
}
