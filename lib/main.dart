import 'package:balancea/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:balancea/config/router/app_router.dart';
import 'package:balancea/domain/entities/transaction.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // Binding
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Splash Nativo
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Inicializacion de locale
  await initializeDateFormatting('es_CO', null);

  // Inicializa Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox('settingsBox');

  // AdMob
  await MobileAds.instance.initialize();

  runApp(ProviderScope(child: Balancea()));
}

class Balancea extends ConsumerWidget {
  const Balancea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Balancea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(scaffoldBackgroundColor: const Color(0xFF191A22)),
      builder: (context, child) => child!,
    );
  }
}
