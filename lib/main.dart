import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  runApp(ProviderScope(child: Balancea()));
}

class Balancea extends StatelessWidget {
  const Balancea({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Balancea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(scaffoldBackgroundColor: const Color(0xFF191A22)),
    );
  }
}
