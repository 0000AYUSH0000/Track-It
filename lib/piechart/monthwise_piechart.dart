import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:track_it/constants.dart';

class MonthwisePieChart extends StatelessWidget {
  final Map<String, double> monthlySummary;

  const MonthwisePieChart({super.key, required this.monthlySummary});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];
    List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    for (int i = 0; i < 12; i++) {
      String month = '${i + 1}-${DateTime.now().year}';
      double amount = monthlySummary[month] ?? 0;
      if(amount!=0){
        sections.add(
          PieChartSectionData(
              value: amount,
              radius: 110,
              titleStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
              title: '${monthNames[i]}\n ${amount.toStringAsFixed(1)}',
              color: kColourList[i]
          ),
        );
      }

    }

    return sections.isNotEmpty?PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 0,
        centerSpaceRadius: 25,
        borderData: FlBorderData(show: false),
      ),
    ): const Padding(
      padding: EdgeInsets.all(45.0),
      child: Text(textAlign: TextAlign.center,'No Expenses\nas of now...',style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
    );
  }
}
