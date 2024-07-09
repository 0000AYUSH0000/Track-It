import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../constants.dart';

class MonthlyGraph extends StatelessWidget {
  final double? maxY;
  final Map<String, double> monthlyExpenses;

  const MonthlyGraph({super.key, this.maxY, required this.monthlyExpenses});

  @override
  Widget build(BuildContext context) {
    double total=0.0;
    List<BarChartGroupData> barGroups = [];

    String formatMonthYear(int month, int year) {
      return '$month-$year';
    }
    List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    List<String> getAllMonthsOfCurrentYear() {
      DateTime now = DateTime.now();
      int currentYear = now.year;
      List<String> months = [];

      for (int month = 1; month <= 12; month++) {
        months.add(formatMonthYear(month, currentYear));
      }

      return months;
    }
    List<String>months=getAllMonthsOfCurrentYear();

    for (int i = 0; i < months.length; i++) {
      double amount = monthlyExpenses[months[i]] ?? 0;
      total=total+amount;
      barGroups.add(
        BarChartGroupData(
          showingTooltipIndicators: [0],
          x: i,
          barRods: [
            BarChartRodData(
              toY: amount,
              color: kColourList[i],
              width: 25,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxY,
                color: Colors.grey[200],
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: barGroups.length * 40.0,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              minY: 0,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      );
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(monthNames[value.toInt()], style: style),
                      );
                    },
                  ),
                ),
              ),
              barGroups: barGroups,
              barTouchData: BarTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(2),
                    direction: TooltipDirection.top,
                    rotateAngle: 0,
                    getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                        ) {
                      return BarTooltipItem(
                          rod.toY.toInt().toString(),
                          const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 12));
                    }),
                enabled: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
