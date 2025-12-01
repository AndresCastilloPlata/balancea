import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:balancea/config/constants/categories_config.dart';
import 'package:balancea/presentation/providers/transaction_provider.dart';
import 'package:balancea/presentation/widgets/stats/chart_container.dart';
import 'package:balancea/presentation/widgets/stats/stats_categories.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  final List<Color> _colors = const [
    Color(0xFF4ECDC4),
    Color(0xFFFF6B6B),
    Color(0xFF7C4DFF),
    Color(0xFFFFD166),
    Color(0xFF118AB2),
    Color(0xFF06D6A0),
  ];

  final Map<String, String> _names = const {
    '🍔': 'Comida',
    '🚌': 'Transporte',
    '💡': 'Servicios',
    '💰': 'Sueldo',
    '🏠': 'Renta',
    '🎁': 'Regalo',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF191A22),
      body: SafeArea(
        child: transactionState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (transactions) {
            // Filtrar gastos
            final expenses = transactions.where((t) => t.isExpense).toList();

            // Datos para categoria
            final Map<String, double> totalsByEmoji = {};
            double totalExpense = 0;

            for (var t in expenses) {
              totalsByEmoji[t.categoryEmoji] =
                  (totalsByEmoji[t.categoryEmoji] ?? 0) + t.amount;
              totalExpense += t.amount;
            }

            final List<CategoryStat> categoryStats = [];
            int colorIndex = 0;

            totalsByEmoji.forEach((emoji, amount) {
              final name = _names[emoji] ?? 'Otro';

              categoryStats.add(
                CategoryStat(
                  emoji: emoji,
                  name: name,
                  amount: amount,
                  percentage: totalExpense > 0 ? (amount / totalExpense) : 0,
                  color: _colors[colorIndex % _colors.length],
                ),
              );
              colorIndex++;
            });

            categoryStats.sort((a, b) => b.amount.compareTo(a.amount));

            // Datos para la grafica
            final Map<int, double> weeklyMap = {
              0: 0,
              1: 0,
              2: 0,
              3: 0,
              4: 0,
              5: 0,
              6: 0,
            };
            double maxDayAmount = 0;

            for (var t in expenses) {
              // weekday devuelve 1 (Lunes) a 7 (Domingo). Restamos 1 para índice 0-6
              final dayIndex = t.date.weekday - 1;
              weeklyMap[dayIndex] = (weeklyMap[dayIndex] ?? 0) + t.amount;

              if (weeklyMap[dayIndex]! > maxDayAmount) {
                maxDayAmount = weeklyMap[dayIndex]!;
              }
            }

            final List<FlSpot> spots = [];
            for (int i = 0; i < 7; i++) {
              spots.add(FlSpot(i.toDouble(), weeklyMap[i]!));
            }

            return Column(
              children: [
                // header
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Análisis Financiero',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Filtros de tiempo
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2D3E),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      _TimeFilterTab(text: 'Semana', isSelected: true),
                      _TimeFilterTab(text: 'Mes', isSelected: false),
                      _TimeFilterTab(text: 'Año', isSelected: false),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Grafica
                ChartContainer(
                  spots: spots,
                  maxY: maxDayAmount > 0
                      ? maxDayAmount
                      : 100, // Evitar división por 0
                ),

                // Resumen gastos
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Gastos por Categoría",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),

                // Lista categorias
                Expanded(child: StatsCategories(categories: categoryStats)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TimeFilterTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const _TimeFilterTab({required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4ECDC4) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
