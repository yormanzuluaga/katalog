/// The code snippet is defining an extension called `StringExtension`
/// on the `String` class in Dart.
extension StringExtension on String {
  String trimLeadingZeroes() => replaceAll(RegExp(r'^0+(?=.)'), '');
  String onlyDigits() => replaceAll(RegExp(r'\D'), '');
  String onlyLetters() => replaceAll(RegExp(r'[^a-zA-Z]'), '');
  String onlyWordsAndSpaces() => replaceAll(RegExp(r'[^\s\w]'), '');
  String removeSpecialCharacters() => replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u');
}
