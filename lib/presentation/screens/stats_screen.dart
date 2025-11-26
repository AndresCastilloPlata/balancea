import 'package:flutter/material.dart';
import 'package:balancea/presentation/widgets/stats/chart_container.dart';
import 'package:balancea/presentation/widgets/stats/stats_categories.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191A22),
      body: SafeArea(
        child: Column(
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
            ChartContainer(),

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
            Expanded(child: StatsCategories()),
          ],
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
