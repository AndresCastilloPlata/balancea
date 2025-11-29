import 'package:intl/intl.dart';

class CurrencyHelper {
  static String format(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$ ',
      decimalDigits: 2,
      customPattern: '\u00A4 #,##0.00',
    );

    return formatter.format(amount);
  }
}
