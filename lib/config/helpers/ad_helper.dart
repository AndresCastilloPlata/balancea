import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  // IDs de prueba
  static const String _androidBannerTestId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _iOSBannerTestId =
      'ca-app-pub-3940256099942544/2934735716';

  // IDs de reales (comentado solo por pruebas)
  // static const String _androidBannerRealId =
  //     'ca-app-pub-4340994501227249/8472446994';
  // static const String _iOSBannerRealId =
  //     'ca-app-pub-4340994501227249/3994145937';

  // Eliminar cuando se lance la app
  static const String _androidBannerRealId = 'TU_AD_UNIT_ID_ANDROID_AQUI';
  static const String _iOSBannerRealId = 'TU_AD_UNIT_ID_IOS_AQUI';

  static String get homeBannerAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode ? _androidBannerTestId : _androidBannerRealId;
    } else if (Platform.isIOS) {
      return kDebugMode ? _iOSBannerTestId : _iOSBannerRealId;
    } else {
      throw UnsupportedError('Plataforma no soportada');
    }
  }
}
