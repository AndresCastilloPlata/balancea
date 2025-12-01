class CategoriesConfig {
  // Diccionario Maestro: Emoji -> Nombre
  static final Map<String, String> allCategories = {
    '🍔': 'Comida',
    '🚌': 'Transporte',
    '💡': 'Servicios',
    '🎬': 'Ocio',
    '💊': 'Salud',
    '🎓': 'Educación',
    '🐶': 'Mascota',
    '✈️': 'Viajes',
    '💰': 'Sueldo',
    '🏦': 'Banco',
    '📈': 'Inversión',
    '🎁': 'Regalo',
    '💎': 'Extra',
    '🏠': 'Renta',
  };

  // Listas para el selector (Solo Keys)
  static final List<String> defaultExpenses = [
    '🍔',
    '🚌',
    '💡',
    '🏠',
    '🎬',
    '💊',
  ];
  static final List<String> defaultIncomes = ['💰', '🏠', '🎁', '📈'];

  // Helper para obtener nombre seguro
  static String getName(String emoji) => allCategories[emoji] ?? 'Otro';
}
