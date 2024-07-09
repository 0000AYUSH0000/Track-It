import '../data/expense_data.dart';
import '../piechart/category_piechart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeeklyCategoryPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weeklySummary = Provider.of<ExpenseData>(context).weeklyCategoryExpenseSummary();
    return CategoryPieChart(
      categorySummary: weeklySummary,
      title: 'Category-Wise Expense\n[Current Week]',
    );
  }
}

class MonthlyCategoryPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monthlySummary = Provider.of<ExpenseData>(context).monthlyCategoryExpenseSummary();
    return CategoryPieChart(
      categorySummary: monthlySummary,
      title: 'Category-Wise Expense\n[Current Month]',
    );
  }
}
