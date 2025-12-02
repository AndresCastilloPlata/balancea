import 'package:balancea/config/helpers/currency_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartContainer extends StatelessWidget {
  final List<FlSpot> spots;
  final double maxY;
  final double maxX;
  final String Function(double) getBottomTitle;
  const ChartContainer({
    super.key,
    required this.spots,
    required this.maxY,
    required this.maxX,
    required this.getBottomTitle,
  });

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
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.black,
              tooltipBorderRadius: BorderRadius.circular(8),
              tooltipPadding: const EdgeInsets.all(8),
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((barSpot) {
                  return LineTooltipItem(
                    CurrencyHelper.format(barSpot.y),
                    const TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
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
                  final text = getBottomTitle(value);

                  if (text.isEmpty) return const SizedBox();
                  return SideTitleWidget(
                    fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                    space: 4,
                    meta: meta,
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  );
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
          minX: 0,
          maxX: maxX,
        ),
      ),
    );
  }
}
