import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:balancea/presentation/providers/transaction_provider.dart';
import '../../../domain/entities/transaction.dart';

class HomeQuickActions extends ConsumerWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionButton(
            icon: Icons.arrow_downward_rounded,
            label: 'Ingreso',
            color: const Color(0xFF4ECDC4),
            onTap: () {
              final newTransaction = Transaction(
                id: const Uuid().v4(), // ID único aleatorio
                title: 'Prueba Ingreso',
                amount: 50000,
                date: DateTime.now(),
                isExpense: false, // Es ingreso
                categoryEmoji: '💰',
                note: 'Guardado desde Hive!',
              );

              ref
                  .read(transactionListProvider.notifier)
                  .addTransaction(newTransaction);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Ingreso guardado en Hive! 🐝')),
              );
            },
          ),
          _ActionButton(
            icon: Icons.arrow_upward_rounded,
            label: 'Gasto',
            color: const Color(0xFFFF6B6B),
            onTap: () {},
          ),
          _ActionButton(
            icon: Icons.qr_code_scanner,
            label: 'Scan',
            color: const Color(0xFF7C4DFF),
            onTap: () {},
          ),
          _ActionButton(
            icon: Icons.grid_view_rounded,
            label: 'Más',
            color: Colors.white,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Circulo boton
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2D3E),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),

        // Etiqueta Texto
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
