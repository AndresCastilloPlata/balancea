import 'package:balancea/config/constants/currency_config.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final AppCurrency currency;

  CurrencyInputFormatter({required this.currency});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Si esta vacio, reconta vacio
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Detectar separadores según el locale
    final format = NumberFormat.currency(locale: currency.locale);
    final String decimalSep = format.symbols.DECIMAL_SEP; // '.' o ','

    // Limpieza inicial
    String cleanText = newValue.text.replaceAll(
      RegExp('[^0-9$decimalSep]'),
      '',
    );
    // Evitar múltiples separadores decimales
    if (cleanText.indexOf(decimalSep) != cleanText.lastIndexOf(decimalSep)) {
      return oldValue;
    }

    List<String> parts = cleanText.split(decimalSep);
    // Parte entera
    String integerPart = parts[0];
    // Separar parte decimal si existe
    String? decimalPart;

    // Limite de 2 decimales
    if (parts.length > 1) {
      decimalPart = parts[1].substring(0, parts[1].length.clamp(0, 2));
    } else if (cleanText.endsWith(decimalSep)) {
      decimalPart = "";
    }

    // Formatear la parte entera con puntos de mil
    final formatter = NumberFormat('#,###', currency.locale);
    String newText = integerPart;

    if (integerPart.isNotEmpty) {
      try {
        newText = formatter.format(int.parse(integerPart));
      } catch (e) {
        return TextEditingValue(
          text: cleanText,
          selection: TextSelection.collapsed(offset: cleanText.length),
        );
      }
    }

    // Reconstruir el texto final
    if (decimalPart != null) {
      newText = '$newText$decimalSep$decimalPart';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
