// ignore_for_file: must_be_immutable
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../date_time/date_time_helper.dart';
import 'package:track_it/constants.dart';

class DaywisePieChart extends StatelessWidget {
  final Map<String, double> dailySummary;
  final DateTime startOfWeek;
  List<String> dayNames=['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];

  DaywisePieChart({super.key, required this.dailySummary, required this.startOfWeek});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];
    for (int i = 0; i < 7; i++) {
      String day = convertDateTimeToString(startOfWeek.add(Duration(days: i)));
      double amount = dailySummary[day] ?? 0;
      if(amount!=0){
        sections.add(
          PieChartSectionData(
              value: amount,
              radius: 110,
              titleStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
              title: '${dayNames[i]}\n ${amount.toStringAsFixed(1)}',
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
    ): Padding(
      padding: const EdgeInsets.all(45.0),
      child: const Text(textAlign: TextAlign.center,'No Expenses\nas of now...',style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
    );
  }
}
