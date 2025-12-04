import 'package:balancea/config/constants/currency_config.dart';
import 'package:intl/intl.dart';

class CurrencyHelper {
  static String format(double amount, AppCurrency currency) {
    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: '${currency.symbol} ',
      decimalDigits: currency.decimals,
      customPattern: '\u00A4 #,##0.00',
    );

    return formatter.format(amount);
  }
}
