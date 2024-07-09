import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:track_it/constants.dart';
import '../data/categories.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> categorySummary;
  final String title;

  const CategoryPieChart({super.key, required this.categorySummary, required this.title});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = categorySummary.entries.map((entry) {
      return PieChartSectionData(
        titlePositionPercentageOffset: 0.6,
        value: entry.value,
        title: '${entry.key}\n${entry.value.toStringAsFixed(1)}',
        color: kColourList[categories.indexOf(entry.key)+1 % kColourList.length],
        radius: 110,
        titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 10),
      );
    }).toList();
    bool isEmpty=true;
    for(int i=0;i<sections.length;i++){
      if(sections[i].value!=0){
        isEmpty=false;
        break;
      }
    }

    return !isEmpty?Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 95,
        ),
        SizedBox(
          height: 120,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 0,
              centerSpaceRadius: 25,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    ): Padding(
      padding: const EdgeInsets.all(45.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(38.0),
            child: Text(
              textAlign: TextAlign.center,
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Text(textAlign: TextAlign.center,'No Expenses\nas of now...',style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}

