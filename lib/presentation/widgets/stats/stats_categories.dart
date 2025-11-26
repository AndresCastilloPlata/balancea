import 'package:flutter/material.dart';

class StatsCategories extends StatelessWidget {
  const StatsCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white, Colors.transparent],
          stops: [0.0, 0.9, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        itemCount: _dummyCategories.length,

        itemBuilder: (context, index) {
          final category = _dummyCategories[index];
          return _CategoryItem(category: category);
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final Map<String, dynamic> category;
  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    final double percentage = category['percentage'];
    final Color color = category['color'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Nombre + Monto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Punto Indicador
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: color.withValues(alpha: 0.5)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    category['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                '\$${category['amount']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Barra progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: const Color(0xFF2A2D3E),
              color: color,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),

          // Texto porcentajo
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(percentage * 100).toInt()}%',
              style: TextStyle(color: Colors.grey[500], fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

// --- DATOS FALSOS ---
final List<Map<String, dynamic>> _dummyCategories = [
  {
    'name': 'Comida y Bebida',
    'amount': '850.000',
    'percentage': 0.45, // 45%
    'color': const Color(0xFF4ECDC4), // Turquesa
  },
  {
    'name': 'Transporte',
    'amount': '320.000',
    'percentage': 0.20, // 20%
    'color': const Color(0xFF7C4DFF), // Violeta
  },
  {
    'name': 'Servicios',
    'amount': '150.000',
    'percentage': 0.10, // 10%
    'color': const Color(0xFFFF6B6B), // Rojo
  },
  {
    'name': 'Entretenimiento',
    'amount': '200.000',
    'percentage': 0.15, // 15%
    'color': Colors.orangeAccent,
  },
];
