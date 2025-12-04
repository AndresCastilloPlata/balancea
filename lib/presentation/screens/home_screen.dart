import 'package:balancea/presentation/providers/settings_provider.dart';
import 'package:balancea/presentation/widgets/shared/banner_ad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/home/home_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // zona fija
            const HomeHeader(),

            // --- AVISO DE SEGURIDAD (Solo si no hay PIN) ---
            if (settings.pin == null)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFFF6B6B,
                  ).withValues(alpha: 0.1), // Fondo rojizo suave
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFFF6B6B),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Tu app no está protegida con PIN.",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navegar a crear PIN
                        context.push('/pin', extra: true);
                      },
                      child: const Text(
                        "Crear",
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: BalanceCard(),
            ),
            const SizedBox(height: 20),
            const BannerAdContainer(),
            const SizedBox(height: 20),
            const HomeQuickActions(),
            const SizedBox(height: 20),

            // zona titulo fijo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transacciones Recientes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Boton "ver todo"
                  GestureDetector(
                    onTap: () {
                      context.go('/transactions');
                    },
                    child: const Text(
                      'Ver todo',
                      style: TextStyle(
                        color: Color(0xFF4ECDC4),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // zona movil
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1F222E),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: const HomeTransactions(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
