import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_it/bar_graph/daily_graph.dart';
import 'package:track_it/constants.dart';
import 'package:track_it/data/expense_data.dart';
import 'package:track_it/date_time/date_time_helper.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfTheWeek;
  const ExpenseSummary({super.key, required this.startOfTheWeek});

  double maxOfSeven(
      double a, double b, double c, double d, double e, double f, double g) {
    return [a, b, c, d, e, f, g]
        .reduce((value, element) => value > element ? value : element);
  }

  double weekTotal(
      double a, double b, double c, double d, double e, double f, double g) {
    return a + b + c + d + e + f + g;
  }

  @override
  Widget build(BuildContext context) {
    String sunday =
        convertDateTimeToString(startOfTheWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startOfTheWeek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startOfTheWeek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startOfTheWeek.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startOfTheWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(startOfTheWeek.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startOfTheWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (BuildContext context, ExpenseData value, Widget? child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7.0, left: 10, bottom: 15),
              child: Row(
                children: [
                  const Text(
                    "Week's Total: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$kRupeeSymbol ${weekTotal(value.dailyExpenseSummary()[sunday] ?? 0, value.dailyExpenseSummary()[monday] ?? 0, value.dailyExpenseSummary()[tuesday] ?? 0, value.dailyExpenseSummary()[wednesday] ?? 0, value.dailyExpenseSummary()[thursday] ?? 0, value.dailyExpenseSummary()[friday] ?? 0, value.dailyExpenseSummary()[saturday] ?? 0).toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: Graph(
                maxY: maxOfSeven(
                        value.dailyExpenseSummary()[sunday] ?? 0,
                        value.dailyExpenseSummary()[monday] ?? 0,
                        value.dailyExpenseSummary()[tuesday] ?? 0,
                        value.dailyExpenseSummary()[wednesday] ?? 0,
                        value.dailyExpenseSummary()[thursday] ?? 0,
                        value.dailyExpenseSummary()[friday] ?? 0,
                        value.dailyExpenseSummary()[saturday] ?? 0) *
                    1.4,
                sunAmount: value.dailyExpenseSummary()[sunday] ?? 0,
                monAmount: value.dailyExpenseSummary()[monday] ?? 0,
                tueAmount: value.dailyExpenseSummary()[tuesday] ?? 0,
                wedAmount: value.dailyExpenseSummary()[wednesday] ?? 0,
                thuAmount: value.dailyExpenseSummary()[thursday] ?? 0,
                friAmount: value.dailyExpenseSummary()[friday] ?? 0,
                satAmount: value.dailyExpenseSummary()[saturday] ?? 0,
              ),
            ),
          ],
        );
      },
    );
  }
}
