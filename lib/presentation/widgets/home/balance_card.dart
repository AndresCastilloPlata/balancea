import 'dart:ui';

import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 220,

      child: Stack(
        children: [
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
                      Colors.white.withValues(alpha: 0.15),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Balance Total',
                      style: TextStyle(color: Colors.grey[300], fontSize: 16),
                    ),
                    const Icon(Icons.credit_card, color: Colors.white70),
                  ],
                ),

                // Saldo
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$ 2,540.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'USD', // Moneda
                      style: TextStyle(
                        color: Color(0xFF4ECDC4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Pie de la card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '**** **** **** 4284',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    // Círculos decorativos simulando Mastercard/Visa
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red.withValues(alpha: 0.8),
                        ),
                        Transform.translate(
                          offset: const Offset(-8, 0), // Superponer círculos
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.orange.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ],
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
