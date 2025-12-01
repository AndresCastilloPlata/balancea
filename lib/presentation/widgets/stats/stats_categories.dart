import 'package:balancea/config/helpers/currency_helper.dart';
import 'package:flutter/material.dart';

class StatsCategories extends StatelessWidget {
  final List<CategoryStat> categories;
  const StatsCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(
        child: Text(
          "No hay gastos registrados",
          style: TextStyle(color: Colors.white54),
        ),
      );
    }
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
        itemCount: categories.length,

        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryItem(category: category);
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryStat category;
  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
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
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        category.emoji,
                        style: const TextStyle(fontSize: 18, height: 1.2),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                CurrencyHelper.format(category.amount),
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
              value: category.percentage,
              backgroundColor: const Color(0xFF2A2D3E),
              color: category.color,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),

          // Texto porcentajo
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(category.percentage * 100).toInt()}%',
              style: TextStyle(color: Colors.grey[500], fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

// Modelo simple para pasar datos limpios a la UI
class CategoryStat {
  final String emoji;
  final String name;
  final double amount;
  final double percentage;
  final Color color;

  CategoryStat({
    required this.emoji,
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}
