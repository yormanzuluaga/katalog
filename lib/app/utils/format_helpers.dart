// ignore_for_file: constant_identifier_names, public_member_api_docs

import 'package:intl/intl.dart';

enum TypeFormat { yyyyMMMdd, ddMMyyyyHHmm, HHmm, HHmmNF, ddMMyyyy, EEEEMMMMdyyyy, ddMMyyyyHHmmText, yyyyMMdd, summary }

enum LocationFormat { es, en }

class AppFormatters {
  AppFormatters._internal();
  static final AppFormatters _instance = AppFormatters._internal();
  static AppFormatters get instance => _instance;
  String dateFormatUtil({
    required DateTime dateTime,
    required TypeFormat typeFormat,
    LocationFormat locationFormat = LocationFormat.es,
  }) {
    final formatter = _generateFormat(typeFormat, locationFormat);
    final formatted = formatter.format(dateTime);
    return formatted;
  }

  String formatOnlyHours(String time) {
    final soloNumero = time.split('T');
    final hora = soloNumero[1].split('.');
    final horaValor = hora[0];
    return horaValor;
  }

  String formatOnlyYear(String time) {
    final soloNumero = time.split('T');
    final anio = soloNumero[0].split('.');
    final yearValor = anio[0];
    return yearValor;
  }

  String dateTimeFromString(String dateTime) {
    final inputFormat = DateFormat('dd/MM/yyyy hh:mm');
    final date = inputFormat.parse(dateTime);
    //DateTime _date = inputFormat.parse(dateTime);
    final dayName = DateFormat('EEEE,', 'es_ES').format(date);
    final monthName = DateFormat('MMMM', 'es_ES').format(date);
    final data = '$dayName ${date.day} de $monthName de ${date.year}';
    return data;
  }

  DateFormat _generateFormat(
    TypeFormat typeFormat,
    LocationFormat locationFormat,
  ) {
    switch (typeFormat) {
      case TypeFormat.yyyyMMMdd:
        // something like 2019-Jun-20
        return DateFormat('yyyy-MMM-dd');
      case TypeFormat.ddMMyyyyHHmm:
        return DateFormat('dd/MM/yy , HH:mm a');
      case TypeFormat.HHmm:
        return DateFormat(
          'HH:mm a',
        );
      case TypeFormat.EEEEMMMMdyyyy:
        return DateFormat('EEEE, MMMM d', generateLocation(locationFormat));
      case TypeFormat.ddMMyyyyHHmmText:
        return DateFormat('MMMM yyyy', generateLocation(locationFormat));
      case TypeFormat.ddMMyyyy:
        return DateFormat('dd/MM/yyyy');
      case TypeFormat.HHmmNF:
        return DateFormat('HH:mm a', generateLocation(locationFormat));
      case TypeFormat.yyyyMMdd:
        return DateFormat('yyyy-MM-dd');
      case TypeFormat.summary:
        return DateFormat('EEE dd MMM yyyy', generateLocation(locationFormat));
    }
  }

  String generateLocation(LocationFormat locationFormat) {
    switch (locationFormat) {
      case LocationFormat.es:
        return 'es';
      case LocationFormat.en:
        return 'en';
    }
  }

  String dateTimeFormatToShow({DateTime? date, TypeFormat format = TypeFormat.ddMMyyyy}) {
    if (date == null) return '';
    return dateFormatUtil(dateTime: date, typeFormat: format);
  }

  DateTime dateTimeStringToDateTime(String? openingDate) {
    if (openingDate == null) return DateTime.now();
    return DateTime.parse(openingDate);
  }

  /// convert String to Double
  double stringToDouble(String number) {
    var newNumber = number;
    try {
      if (number.contains(',')) {
        newNumber = number.replaceAll(',', '.');
      }
      return double.parse(newNumber);
    } catch (_) {
      return 0;
    }
  }

  /// convert Double to String with 2 decimals and currency
  String doubleToStringCurrency(double number) {
    return '\$ ${number.toStringAsFixed(2)}';
  }

  /// convert String to String with 2 decimals and currency
  String stringToStringCurrency(String number) {
    return '\$ ${stringToDouble(number).toStringAsFixed(2)}';
  }

  String parseNumberFormat(String number) {
    final numberFormat = number.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
    return numberFormat;
  }

  String uuidToShortString(String uuid) {
    final paramUuid = uuid.split('-');
    return paramUuid[0];
  }

  /// Capitalize firt letter of a sentence
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String formatterNumberCredential(String responseCredential) {
    return '${responseCredential.substring(0, 6)} '
        '${responseCredential.substring(6, 13)} '
        '${responseCredential.substring(13, 15)} '
        '${responseCredential.substring(15, 19)}';
  }
}
