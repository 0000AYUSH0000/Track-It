import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_it/constants.dart';
import '../bar_graph/monthly_graph.dart';
import '../data/expense_data.dart';

class MonthlyExpenseSummary extends StatelessWidget {
  final Map<String, double> monthlySummary;


  const MonthlyExpenseSummary({
    super.key,
    required this.monthlySummary,
  });

  @override
  Widget build(BuildContext context) {
    double yearlyTotal = monthlySummary.values.isNotEmpty ? monthlySummary.values.reduce((a, b) => a + b) : 0;
    return Consumer<ExpenseData>(
      builder: (BuildContext context, ExpenseData value, Widget? child) {
        // Get monthly expenses summary
        Map<String, double> monthlySummary = value.monthlyExpenseSummary();
        double maxMonthly = monthlySummary.values.isNotEmpty ? monthlySummary.values.reduce((a, b) => a > b ? a : b) : 0;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Year's Total:$kRupeeSymbol $yearlyTotal",
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold,color: Colors.black87),
                  ),
                ],
              ),
            ),
            MonthlyGraph(
              maxY: maxMonthly*1.4,
              monthlyExpenses: monthlySummary,
            ),
          ],
        );
      },
    );
  }
}
