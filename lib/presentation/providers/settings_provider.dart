import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppSettings {
  final bool isDarkTheme;
  final bool isBiometricEnabled;
  final bool areNotificationsEnabled;

  AppSettings({
    this.isDarkTheme = true,
    this.isBiometricEnabled = false,
    this.areNotificationsEnabled = true,
  });

  AppSettings copyWith({
    bool? isDarkTheme,
    bool? isBiometricEnabled,
    bool? areNotificationsEnabled,
  }) {
    return AppSettings(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      areNotificationsEnabled:
          areNotificationsEnabled ?? this.areNotificationsEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  static const String _boxName = 'settingsBox';

  SettingsNotifier() : super(_getInitialState());

  static AppSettings _getInitialState() {
    final box = Hive.box(_boxName);

    // Valores primera vez por defecto
    return AppSettings(
      isDarkTheme: box.get('isDarkTheme', defaultValue: true),
      isBiometricEnabled: box.get('isBiometricEnabled', defaultValue: false),
      areNotificationsEnabled: box.get(
        'areNotificationsEnabled',
        defaultValue: true,
      ),
    );
  }

  // Notificaciones
  void toggleNotifications(bool value) async {
    state = state.copyWith(areNotificationsEnabled: value);

    final box = await Hive.openBox(_boxName);
    await box.put('areNotoficationsEnabled', value);
  }

  // Biometria
  void toggleBiometric(bool value) async {
    state = state.copyWith(isBiometricEnabled: value);

    final box = await Hive.openBox(_boxName);
    await box.put('isBiometricEnabled', value);
  }

  // Tema
  void toggleTheme(bool value) async {
    state = state.copyWith(isDarkTheme: value);

    final box = await Hive.openBox(_boxName);
    await box.put('isDarkTheme', value);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((
  ref,
) {
  return SettingsNotifier();
});
