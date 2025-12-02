import 'package:balancea/config/constants/categories_config.dart';
import 'package:balancea/domain/entities/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:balancea/config/constants/categories_config.dart';
import 'package:balancea/presentation/providers/transaction_provider.dart';
import 'package:balancea/presentation/widgets/stats/chart_container.dart';
import 'package:balancea/presentation/widgets/stats/stats_categories.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _selectedFilterIndex = 0;

  final List<Color> _colors = const [
    Color(0xFF4ECDC4),
    Color(0xFFFF6B6B),
    Color(0xFF7C4DFF),
    Color(0xFFFFD166),
    Color(0xFF118AB2),
    Color(0xFF06D6A0),
  ];

  // Filtrar transacciones
  List<Transaction> _filterTransactionsByDate(
    List<Transaction> allTransactions,
  ) {
    final now = DateTime.now();
    final expenses = allTransactions.where((t) => t.isExpense).toList();

    return expenses.where((t) {
      if (_selectedFilterIndex == 0) {
        // Semana
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

        final start = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );

        return t.date.isAfter(start) || t.date.isAtSameMomentAs(start);
      } else if (_selectedFilterIndex == 1) {
        // Mes
        return t.date.month == now.month && t.date.year == now.year;
      } else {
        // Año
        return t.date.year == now.year;
      }
    }).toList();
  }

  // Datos para la grafica (polimorfismo de ejes)
  _ChartData _prepareChartData(List<Transaction> transactions) {
    final Map<int, double> map = {};
    double maxAmount = 0;
    double maxX = 6; // semana(0-6)

    if (_selectedFilterIndex == 0) {
      // Semana
      maxX = 6;

      for (int i = 0; i <= 6; i++) {
        map[i] = 0;
      }

      for (var t in transactions) {
        final index = t.date.weekday - 1;
        map[index] = (map[index] ?? 0) + t.amount;
      }
    } else if (_selectedFilterIndex == 1) {
      // Mes
      final now = DateTime.now();
      final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
      maxX = (daysInMonth - 1).toDouble();

      for (int i = 0; i < daysInMonth; i++) {
        map[i] = 0;
      }

      for (var t in transactions) {
        final index = t.date.day - 1;
        map[index] = (map[index] ?? 0) + t.amount;
      }
    } else {
      // Año
      maxX = 11;
      for (int i = 0; i <= 11; i++) map[i] = 0;

      for (var t in transactions) {
        final index = t.date.month - 1;
        map[index] = (map[index] ?? 0) + t.amount;
      }
    }

    // Encontrar el valor en Y mas alto para escalar grafica
    map.forEach((key, value) {
      if (value > maxAmount) maxAmount = value;
    });

    // Convertir mapa a FlSpots
    final List<FlSpot> spots =
        map.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList()
          ..sort((a, b) => a.x.compareTo(b.x)); // Ordenar por eje X

    return _ChartData(spots: spots, maxY: maxAmount, maxX: maxX);
  }

  // Etiquetas eje X
  String _getBottomTitle(double value) {
    final index = value.toInt();

    if (_selectedFilterIndex == 0) {
      // SEMANA: L, M, M...
      const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
      if (index >= 0 && index < days.length) return days[index];
    } else if (_selectedFilterIndex == 1) {
      // MES: 1, 5, 10, 15... (Para no saturar)
      // Mostramos solo múltiplos de 5 y el 1
      final now = DateTime.now();
      final totalDays = DateUtils.getDaysInMonth(now.year, now.month);
      final day = index + 1;

      if (day == 1 || day == totalDays) {
        return day.toString();
      }
      if (day % 5 == 0 && (totalDays - day) > 1) {
        return day.toString();
      }
      return ''; // Ocultar otros días para limpieza visual
    } else {
      // AÑO:
      const months = [
        'Ene',
        'Feb',
        'Mar',
        'Abr',
        'May',
        'Jun',
        'Jul',
        'Ago',
        'Sep',
        'Oct',
        'Nov',
        'Dic',
      ];
      if (index >= 0 && index < months.length) return months[index];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF191A22),
      body: SafeArea(
        child: transactionState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (allTransactions) {
            // Filtrar gastos
            final filteredExpenses = _filterTransactionsByDate(allTransactions);

            // Datos Grafica
            final chartData = _prepareChartData(filteredExpenses);

            // Datos para categoria
            final Map<String, double> totalsByEmoji = {};
            double totalExpense = 0;

            for (var t in filteredExpenses) {
              totalsByEmoji[t.categoryEmoji] =
                  (totalsByEmoji[t.categoryEmoji] ?? 0) + t.amount;
              totalExpense += t.amount;
            }

            final List<CategoryStat> categoryStats = [];
            int colorIndex = 0;

            totalsByEmoji.forEach((emoji, amount) {
              final name = CategoriesConfig.getName(emoji);

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
                      _TimeFilterTab(
                        text: 'Semana',
                        isSelected: _selectedFilterIndex == 0,
                        onTap: () => setState(() => _selectedFilterIndex = 0),
                      ),
                      _TimeFilterTab(
                        text: 'Mes',
                        isSelected: _selectedFilterIndex == 1,
                        onTap: () => setState(() => _selectedFilterIndex = 1),
                      ),
                      _TimeFilterTab(
                        text: 'Año',
                        isSelected: _selectedFilterIndex == 2,
                        onTap: () => setState(() => _selectedFilterIndex = 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Grafica
                ChartContainer(
                  spots: chartData.spots,
                  maxY: chartData.maxY > 0
                      ? chartData.maxY
                      : 100, // Evitar división por 0
                  maxX: chartData.maxX,
                  getBottomTitle: _getBottomTitle,
                  bottomTitleAngle: _selectedFilterIndex == 2 ? -0.6 : 0.0,
                  bottomReservedSize: _selectedFilterIndex == 2 ? 40.0 : 30.0,
                ),

                // Resumen gastos
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _selectedFilterIndex == 0
                          ? "Gastos esta semana"
                          : _selectedFilterIndex == 1
                          ? "Gastos este mes"
                          : "Gastos este año",
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

class _ChartData {
  final List<FlSpot> spots;
  final double maxY;
  final double maxX;

  _ChartData({required this.spots, required this.maxY, required this.maxX});
}

class _TimeFilterTab extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeFilterTab({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
      ),
    );
  }
}
