import 'package:flutter/material.dart';
import 'package:balancea/config/router/app_router.dart';

void main() => runApp(const Balancea());

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
