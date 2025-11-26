import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartContainer extends StatelessWidget {
  const ChartContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // Base
    return Container(
      height: 300,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
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
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(color: Colors.grey, fontSize: 10);
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = 'LUN';
                      break;
                    case 2:
                      text = 'MIE';
                      break;
                    case 4:
                      text = 'VIE';
                      break;
                    case 6:
                      text = 'DOM';
                      break;
                    default:
                      return Container(); // Ocultar otros días para no amontonar
                  }
                  return Text(text, style: style);
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
              spots: const [
                //Dia|Monto
                FlSpot(0, 3), // Lunes
                FlSpot(1, 1), // Martes (Bajó)
                FlSpot(2, 4), // Miercoles (Subió)
                FlSpot(3, 2),
                FlSpot(4, 5), // Viernes (Pico)
                FlSpot(5, 3),
                FlSpot(6, 4),
              ],
              isCurved: true,
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
        ),
      ),
    );
  }
}
