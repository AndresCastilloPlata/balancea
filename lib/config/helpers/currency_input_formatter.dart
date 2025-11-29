import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Si esta vacio, reconta vacio
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Limpieza inicial
    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9,]'), '');

    List<String> parts = cleanText.split(',');

    // Parte entera
    String integerPart = parts[0];

    // Separar parte decimal si existe
    String? decimalPart;

    // Limite de 2 decimales
    if (parts.length > 1) {
      decimalPart = parts[1].substring(0, parts[1].length.clamp(0, 2));
    } else if (cleanText.endsWith(',')) {
      integerPart = "";
    }

    // Formatear la parte entera con puntos de mil

    final formatter = NumberFormat('#,###', 'es_CO');
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
      newText = '$newText,$decimalPart';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
