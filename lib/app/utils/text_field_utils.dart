import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template card_number_formatter}
/// Card number formatter
/// {@endtemplate}
class CardFormatter extends TextInputFormatter {
  /// {@macro card_number_formatter}
  CardFormatter({
    required this.separator,
    required this.valueSeparate,
    this.onlyDigits = false,
  });

  /// Separator
  final String separator;

  /// Value separate
  final int valueSeparate;

  /// Only digits
  final bool onlyDigits;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final oldS = oldValue.text;
    final newS = newValue.text;
    var endsWithSeparator = false;
    final validation = RegExp(r'^[0-9\-\/]*$');

    if (onlyDigits && !validation.hasMatch(newS)) {
      return oldValue;
    }

    // if you add text
    if (newS.length > oldS.length) {
      for (final char in separator.characters) {
        if (newS.substring(0, newS.length - 1).endsWith(char)) {
          endsWithSeparator = true;
        }
      }
      final clean = newS.replaceAll(separator, '');
      if (!endsWithSeparator && clean.length > 1 && clean.length % valueSeparate == 1) {
        return newValue.copyWith(
          text: newS.substring(0, newS.length - 1) + separator + newS.characters.last,
          selection: TextSelection.collapsed(
            offset: newValue.selection.end + separator.length,
          ),
        );
      }
    }

    // if you delete text
    if (newS.length < oldS.length) {
      for (final char in separator.characters) {
        if (oldS.substring(0, oldS.length - 1).endsWith(char)) {
          endsWithSeparator = true;
        }
      }
      final clean = oldS.substring(0, oldS.length - 1).replaceAll(separator, '');
      if (endsWithSeparator && clean.isNotEmpty && clean.length % valueSeparate == 0) {
        return newValue.copyWith(
          text: newS.substring(0, newS.length - separator.length),
          selection: TextSelection.collapsed(
            offset: newValue.selection.end - separator.length,
          ),
        );
      }
    }

    return newValue;
  }
}

/// Function adds a cahracter to the beginning of text fields value.
TextInputFormatter singleCharacterPrefixTextFormatter(String prefixChar) {
  if (prefixChar.length != 1) {
    throw Exception(
      '"$prefixChar" can\'t be longer than 1 character long.',
    );
  }

  return TextInputFormatter.withFunction(
    (oldValue, newValue) {
      final newText = newValue.text.replaceFirst(prefixChar, '');
      final value = prefixChar + newText;

      var selection = newValue.selection;

      if (value == prefixChar) {
        selection = TextSelection.collapsed(offset: value.length);
      }

      if (value.length == prefixChar.length + 1) {
        selection = TextSelection.collapsed(offset: value.length);
      }

      return TextEditingValue(
        selection: selection,
        text: value,
      );
    },
  );
}

/// Cleans up the prefix added in singleCharacterPrefixTextFormatter()
String cleanSingleCharacterPrefixText(String value, String prefixChar) {
  if (prefixChar.length != 1) {
    throw Exception(
      '"$prefixChar" can\'t be longer than 1 character long.',
    );
  }

  return value.replaceFirst(prefixChar, '');
}

/// Emoji regex
final RegExp emojiRegex = RegExp(
  r'[^\u0000-\u007F]', // This regex matches any character outside the basic ASCII range (i.e., emojis and other symbols).
);

/// Removing emoji in input text and remaining cursor index
/// Example: 'Hello, welcome to Flutter 😀!' => 'Hello, welcome to Flutter !'
class RemoveEmojiInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(emojiRegex, '');

    var selection = newValue.selection;
    if (oldValue.text == text) {
      selection = oldValue.selection;
    }
    return TextEditingValue(text: text, selection: selection);
  }
}
