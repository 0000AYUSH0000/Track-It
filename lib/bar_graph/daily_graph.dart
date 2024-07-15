import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:track_it/constants.dart';
import 'bar_data.dart';



class Graph extends StatelessWidget {
  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;

  const Graph({
    super.key,
    this.maxY,
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(

      monAmount: monAmount,
      tueAmount: tueAmount,
      wedAmount: wedAmount,
      thuAmount: thuAmount,
      friAmount: friAmount,
      satAmount: satAmount,
      sunAmount: sunAmount,
    );

    return BarChart(
      BarChartData(
        maxY: maxY ?? 100,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups: myBarData.barData.map(
          (data) {
            return BarChartGroupData(
              showingTooltipIndicators: [0],
              x: data.x,
              barRods: [
                BarChartRodData(
                  toY: data.y,
                  color: kColourList[data.x],
                  width: 25,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY ?? 100, // Default to 100 if maxY is not provided
                    color: Colors.grey[200],
                  ),
                ),
              ],
            );
          },
        ).toList(),
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
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12));
              }),
          enabled: true,
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  Widget text;
  switch (value.toInt()) {
    case 6:
      text = const Text('S', style: style);
      break;
    case 0:
      text = const Text('S', style: style);
      break;
    case 1:
      text = const Text('M', style: style);
      break;
    case 2:
      text = const Text('T', style: style);
      break;
    case 3:
      text = const Text('W', style: style);
      break;
    case 4:
      text = const Text('T', style: style);
      break;
    case 5:
      text = const Text('F', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4, // Add some space to align the title properly
    child: text,
  );
}
