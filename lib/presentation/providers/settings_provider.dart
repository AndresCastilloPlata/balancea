import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppSettings {
  final bool isDarkTheme;
  final bool isBiometricEnabled;
  final bool areNotificationsEnabled;

  final String userName;
  final String? avatarPath;
  final String? pin;

  AppSettings({
    this.isDarkTheme = true,
    this.isBiometricEnabled = false,
    this.areNotificationsEnabled = true,
    this.userName = 'Usuario',
    this.avatarPath,
    this.pin,
  });

  AppSettings copyWith({
    bool? isDarkTheme,
    bool? isBiometricEnabled,
    bool? areNotificationsEnabled,
    String? userName,
    String? avatarPath,
    String? pin,
  }) {
    return AppSettings(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      areNotificationsEnabled:
          areNotificationsEnabled ?? this.areNotificationsEnabled,
      userName: userName ?? this.userName,
      avatarPath: avatarPath ?? this.avatarPath,
      pin: pin ?? this.pin,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  static const String _boxName = 'settingsBox';
  static const String _transactionsBoxName = 'transactionsBox';

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
      userName: box.get('userName', defaultValue: 'Usuario'),
      avatarPath: box.get('avatarPath'), // null por defecto
      pin: box.get('pin'),
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

  // Perfil
  void updateProfile({String? name, String? path}) {
    state = state.copyWith(
      userName: name ?? state.userName,
      avatarPath: path ?? state.avatarPath,
    );

    final box = Hive.box(_boxName);
    if (name != null) box.put('userName', name);
    if (path != null) box.put('avatarPath', path);
  }

  // PIN
  void setPin(String newPin) {
    state = state.copyWith(pin: newPin);
    Hive.box(_boxName).put('pin', newPin);
  }

  // Borrar datos
  Future<void> clearAllData() async {
    final settingsBox = Hive.box(_boxName);

    // 1. Borramos configuración (pero mantenemos el tema oscuro para que no flashée feo)
    await settingsBox.clear();
    // Restauramos defaults mínimos
    await settingsBox.put('isDarkTheme', true);

    // 2. Borramos Transacciones (Si la caja está abierta)
    if (Hive.isBoxOpen(_transactionsBoxName)) {
      // Ojo: Verifica el nombre exacto en tu repo
      await Hive.box(_transactionsBoxName).clear();
    } else {
      // Si no está abierta, intentamos abrir y borrar
      final tBox = await Hive.openBox(_transactionsBoxName);
      await tBox.clear();
    }

    // 3. Reseteamos el estado en memoria
    state = AppSettings(isDarkTheme: true, userName: 'Usuario');
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((
  ref,
) {
  return SettingsNotifier();
});
