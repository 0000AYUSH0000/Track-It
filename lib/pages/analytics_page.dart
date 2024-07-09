import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_it/components/card.dart';
import 'package:track_it/components/category_expense_summary.dart';
import 'package:track_it/constants.dart';
import '../data/expense_data.dart';
import '../date_time/date_time_helper.dart';
import '../piechart/day_wise_piechart.dart';
import '../piechart/monthwise_piechart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text(
          'Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ExpenseData>(
        builder: (context, expenseData, child) {
          DateTime now = DateTime.now();
          DateTime startOfWeek = expenseData.startOfWeekDate()!;
          Map<String, double> dailySummary = expenseData.dailyExpenseSummary();
          Map<String, double> monthlySummary =
              expenseData.monthlyExpenseSummary();

          double maxWeeklyAmount = 0;
          String highestDayOfWeek = '';
          double maxMonthlyAmount = 0;
          String highestMonthOfYear = '';

          // Calculate highest transaction day of the current week
          for (int i = 0; i < 7; i++) {
            String day =
                convertDateTimeToString(startOfWeek.add(Duration(days: i)));
            String temp = convert(startOfWeek.add(Duration(days: i)));
            double amount = dailySummary[day] ?? 0;
            if (amount > maxWeeklyAmount) {
              maxWeeklyAmount = amount;
              highestDayOfWeek = temp;
            }
          }

          // Calculate highest transaction day of the current month
          int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
          for (int i = 1; i <= daysInMonth; i++) {
            String day =
                convertDateTimeToMonthYear(DateTime(now.year, now.month, i));
            String temp = convertDateTimeToMonthYear(DateTime(now.year, now.month, i));
            double amount = monthlySummary[day] ?? 0;
            if (amount > maxMonthlyAmount) {
              maxMonthlyAmount = amount;
              highestMonthOfYear = temp;
            }
          }

          //avg daily expense in current week
          double averageDailyExpenseCurrentWeek() {
            DateTime startOfWeek = expenseData.startOfWeekDate()!;
            DateTime today = DateTime.now();


            double total = 0;
            int days = today.weekday;
            print(today.weekday);


            for (var expense in expenseData.getAllExpenseList()) {
              if (expense.dateTime.isAfter(startOfWeek) && expense.dateTime.isBefore(today)) {
                total += expense.amount;
              }
            }

            return days > 0 ? total / days : 0;
          }
          double dailyAvgForCurrentWeek=averageDailyExpenseCurrentWeek();


          //monthly avg for current year
          double averageMonthlyExpenseCurrentYear() {
            DateTime startOfYear = expenseData.startOfYearDate();
            DateTime today = DateTime.now();

            double total = 0;
            int months = 0;

            for (var expense in expenseData.getAllExpenseList()) {
              if (expense.dateTime.isAfter(startOfYear) && expense.dateTime.isBefore(today)) {
                total += expense.amount;
                months = today.month - startOfYear.month + 1;
              }
            }

            return months > 0 ? total / months : 0;
          }
          double monthlyAvgForCurrentYear=averageMonthlyExpenseCurrentYear();



          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    CardBox(
                        text:
                            'Highest Transaction Day of the Current Week: $highestDayOfWeek\n\n[ $kRupeeSymbol $maxWeeklyAmount ]'),
                    CardBox(
                        text:
                            'Highest Transaction Month of the Current Year: $highestMonthOfYear\n\n[ $kRupeeSymbol $maxMonthlyAmount ]')
                  ],
                ),
                Row(
                  children: [
                    CardBox(text: 'Daily Average of the Current Week:$kRupeeSymbol ${dailyAvgForCurrentWeek.toStringAsFixed(2)}'),
                    CardBox(text: 'Monthly Average of the Current Year:\n$kRupeeSymbol ${monthlyAvgForCurrentYear.toStringAsFixed(2)}')
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  'Day-Wise Expense\n[Current Week]',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 240,
                  child: DaywisePieChart(
                      dailySummary: dailySummary,
                      startOfWeek: startOfWeek),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  'Month-Wise Expense\n[Current Year]',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 240,
                  child:
                      MonthwisePieChart(monthlySummary: monthlySummary),
                ),
                const SizedBox(
                  height: 30,
                ),
                Divider(),
                const SizedBox(
                  height: 30,
                ),
                MonthlyCategoryPieChart(),
                SizedBox(height: 95),
                WeeklyCategoryPieChart(),
                SizedBox(height: 95),

              ],
            ),
          );
        },
      ),
    );
  }
}
