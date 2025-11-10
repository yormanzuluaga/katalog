/// The code snippet is defining an extension called `StringCasingExtension`
/// on the `String` class in Dart.
extension StringCasingExtension on String {
  /// The function converts the first character of a string to uppercase and the rest of the characters
  /// to lowercase.
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  /// The function converts a string to title case by capitalizing the first letter of each word.
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
