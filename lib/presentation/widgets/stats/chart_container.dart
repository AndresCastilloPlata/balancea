import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartContainer extends StatelessWidget {
  final List<FlSpot> spots;
  final double maxY;
  const ChartContainer({super.key, required this.spots, required this.maxY});

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: Text(
            "Sin datos recientes",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    // Base
    return Container(
      height: 300,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1F222E),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      // Grafica
      child: LineChart(
        LineChartData(
          maxY: maxY * 1.1, // Un 10% más de aire arriba
          minY: 0,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white.withValues(alpha: 0.05),
                strokeWidth: 1,
              );
            },
          ),

          // Bordes
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            // Etiqueta inferior (X -> tiempo)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                  final index = value.toInt();

                  if (index >= 0 && index < days.length) {
                    return SideTitleWidget(
                      fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                      space: 4,
                      meta: meta,
                      child: Text(
                        days[index],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false), // sin marco cadrado
          // Datos
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              preventCurveOverShooting: true,
              color: const Color(0xFF4ECDC4),
              barWidth: 3,
              isStrokeCapRound: true,

              // Punto de cada dato
              dotData: const FlDotData(show: false),

              // area sombreada bajo la curva
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                    const Color(0xFF4ECDC4).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
          minX: -0.2,
          maxX: 6.2,
        ),
      ),
    );
  }
}
