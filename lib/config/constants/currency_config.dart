class AppCurrency {
  final String code; // 'COP', 'USD', 'EUR'
  final String name; // 'Peso Colombiano'
  final String symbol; // '$'
  final String locale; // 'es_CO', 'en_US'
  final int decimals; // 0 o 2

  const AppCurrency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.locale,
    this.decimals = 0,
  });
}

class CurrencyConfig {
  static const List<AppCurrency> availableCurrencies = [
    AppCurrency(
      code: 'COP',
      name: 'Peso Colombiano',
      symbol: '\$',
      locale: 'es_CO',
      decimals: 0, // Visualmente solemos ocultar decimales en COP
    ),
    AppCurrency(
      code: 'USD',
      name: 'Dólar Estadounidense',
      symbol: '\$',
      locale: 'en_US', // Usa punto para decimales
      decimals: 2,
    ),
    AppCurrency(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      locale: 'es_ES', // Formato europeo estándar
      decimals: 2,
    ),
  ];

  static AppCurrency getCurrency(String code) {
    return availableCurrencies.firstWhere(
      (c) => c.code == code,
      orElse: () => availableCurrencies.first, // Default COP
    );
  }
}
