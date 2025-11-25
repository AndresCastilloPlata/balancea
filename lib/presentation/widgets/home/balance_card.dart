import 'dart:ui';

import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // Capa 0: Fondo base
            Container(color: const Color(0xFF1F222E)),

            // Capa 1: luces aurora
            // Luz 1: violeta
            const Positioned(
              top: -50,
              left: -50,
              child: _DecorationLight(color: Color(0xFF7C4DFF)),
            ),
            // Luz 2: turquesa
            const Positioned(
              bottom: -50,
              right: -50,
              child: _DecorationLight(color: Color(0xFF4ECDC4)),
            ),

            // Capa 2: Efecto de vidrio
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  // efecto brillo/reflejo
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Contenido de la card
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Encabezado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Balance Total',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Cuenta principal
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Premium ⭐',
                              style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // icono decorativo
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        child: const Icon(
                          Icons.wallet,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  // Monto
                  Text(
                    '\$ 2,540.000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Indicadores  Ingresos|Gastos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Ingresos
                      _GlasStat(
                        icon: Icons.arrow_downward,
                        color: const Color(0xFF4ECDC4), // Verde Neon
                        label: 'Ingresos',
                        amount: '\$ 3.2M',
                      ),

                      // Gastos
                      _GlasStat(
                        icon: Icons.arrow_upward,
                        color: const Color(0xFFFF6B6B), // Rojo Neon
                        label: 'Gastos',
                        amount: '\$ 850k',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecorationLight extends StatelessWidget {
  final Color color;
  const _DecorationLight({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.5),
        boxShadow: [BoxShadow(color: color, blurRadius: 60, spreadRadius: 10)],
      ),
    );
  }
}

class _GlasStat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String amount;

  const _GlasStat({
    required this.icon,
    required this.color,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Circulo con icono
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[300], fontSize: 12),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
