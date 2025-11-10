/// Extension to group special formats in app
extension SpecialFormats on String {
  /// Returns an string formatted to credential number
  String formatCredential() {
    return '${substring(0, 6)} '
        '${substring(6, 13)} '
        '${substring(13, 15)} '
        '${substring(15, 19)}';
  }

  /// Capitalize the first letter.
  String capitalize() {
    if (isEmpty) return '';
    if (length == 1) return toUpperCase();

    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalize each word.
  String capitalizeAllWords() {
    if (isEmpty) return '';
    if (length == 1) return toUpperCase();

    final words = split(' ');
    final buffer = StringBuffer();

    for (final word in words) {
      buffer
        ..write(word.capitalize())
        ..write(' ');
    }

    return buffer.toString().trimRight();
  }
}

extension StringExtension on String? {
  bool get isNotNullOrEmpty => isNull && this!.isNotEmpty;
}

extension NullableObjectExt<T extends Object> on T? {
  bool get isNull => this == null;
  bool get isNotNull => !isNull;
}
