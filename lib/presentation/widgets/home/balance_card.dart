import 'dart:ui';

import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,

      child: Stack(
        children: [
          // Luces de fondo
          const Positioned(
            top: -20,
            right: -20,
            child: _DecorationLight(color: Color(0xFF4ECDC4)),
          ),
          // Luces de fondo
          const Positioned(
            bottom: -20,
            left: -20,
            child: _DecorationLight(color: Color(0xFFFF6B6B)),
          ),

          // Efecto de vidrio
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  // efecto brillo/reflejo
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
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
                Text(
                  'Balance Total',
                  style: TextStyle(color: Colors.grey[300], fontSize: 16),
                ),
                const SizedBox(height: 10),
                // Monto
                Text(
                  '\$ 2,540.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 20),

                // Fila Ingresos|Gastos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Indicador de Ingresos
                    _MiniIndicator(
                      icon: Icons.arrow_upward_rounded,
                      color: const Color(0xFF4ECDC4), // Verde Neon
                      label: 'Ingresos',
                      amount: '\$ 3.2M',
                    ),

                    // Indicador de Gastos
                    _MiniIndicator(
                      icon: Icons.arrow_downward_rounded,
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

class _MiniIndicator extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String amount;

  const _MiniIndicator({
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
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
