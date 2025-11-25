import 'package:flutter/material.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionButton(
            icon: Icons.add_circle_outline,
            label: 'Recargar',
            color: const Color(0xFF4ECDC4),
            onTap: () {
              print('Recargar presionado');
            },
          ),
          _ActionButton(
            icon: Icons.remove_circle_outline,
            label: 'Enviar',
            color: const Color(0xFFFF6B6B),
            onTap: () {
              print('Enviar presionado');
            },
          ),
          _ActionButton(
            icon: Icons.qr_code_scanner,
            label: 'Escanear',
            color: const Color(0xFF7C4DFF),
            onTap: () {},
          ),
          _ActionButton(
            icon: Icons.more_horiz,
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
