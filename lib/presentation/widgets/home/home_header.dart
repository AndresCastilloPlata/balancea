import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Saludo + nombre
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido de nuevo',
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
              ),
              const SizedBox(height: 4),
              Text(
                'Ingeniero',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // Avatar
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF4ECDC4), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFF2A2D3E),
              child: Text('👨‍💻', style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }
}
