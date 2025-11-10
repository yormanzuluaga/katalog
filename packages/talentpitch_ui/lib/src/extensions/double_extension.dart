import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String toCurrency() {
    final formatter = NumberFormat('#,##0.00', 'es_AR');
    return formatter.format(this);
  }
}
