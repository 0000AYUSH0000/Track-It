// expense_data.dart
import 'package:flutter/widgets.dart';
import 'hive_database.dart';
import 'package:track_it/date_time/date_time_helper.dart';
import 'package:track_it/models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  List<ExpenseItem> overallExpenseList = [];
  final db = HiveDatabase();

  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
      overallExpenseList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void addNewExpense(ExpenseItem expenseItem) {
    overallExpenseList.add(expenseItem);
    overallExpenseList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    db.saveData(overallExpenseList);
  }

  void deleteExpense(ExpenseItem expenseItem) {
    overallExpenseList.remove(expenseItem);
    overallExpenseList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    db.saveData(overallExpenseList);
  }

  void editExpense(String newName, double newAmount, DateTime expenseDate,
      String newCategory,String newCategoryIcon) {
    ExpenseItem updatedExpense = ExpenseItem(
        name: newName,
        amount: newAmount,
        dateTime: expenseDate,
        category: newCategory,
    categoryIcon: newCategoryIcon);
    db.editData(expenseDate, updatedExpense);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    prepareData();
  }

  DateTime? startOfWeekDate() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek;
  }

  DateTime startOfYearDate() {
    DateTime today = DateTime.now();
    return DateTime(today.year, 1, 1);
  }


  Map<String, double> dailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = expense.amount;

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }

  Map<String, double> monthlyExpenseSummary() {
    Map<String, double> monthlyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String month = convertDateTimeToMonthYear(expense.dateTime);
      double amount = expense.amount;

      if (monthlyExpenseSummary.containsKey(month)) {
        double currentAmount = monthlyExpenseSummary[month]!;
        currentAmount += amount;
        monthlyExpenseSummary[month] = currentAmount;
      } else {
        monthlyExpenseSummary.addAll({month: amount});
      }
    }

    return monthlyExpenseSummary;
  }
  Map<String, double> weeklyCategoryExpenseSummary() {
    Map<String, double> weeklyCategorySummary = {};
    DateTime startOfWeek = startOfWeekDate()!;
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    for (var expense in overallExpenseList) {
      if (expense.dateTime.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
          expense.dateTime.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        if (weeklyCategorySummary.containsKey(expense.category)) {
          weeklyCategorySummary[expense.category] = (weeklyCategorySummary[expense.category] ?? 0) + expense.amount;
        } else {
          weeklyCategorySummary[expense.category]=expense.amount;
        }
      }
    }

    return weeklyCategorySummary;
  }


  // Category-wise expense summary for the current month
  Map<String, double> monthlyCategoryExpenseSummary() {
    Map<String, double> monthlyCategorySummary = {};
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    for (var expense in overallExpenseList) {
      if (expense.dateTime.isAfter(startOfMonth) || expense.dateTime.isAtSameMomentAs(startOfMonth)) {
        if (monthlyCategorySummary.containsKey(expense.category)) {
          monthlyCategorySummary[expense.category] = (monthlyCategorySummary[expense.category] ?? 0) + expense.amount;
        } else {
          monthlyCategorySummary[expense.category] = expense.amount;
        }
      }
    }

    return monthlyCategorySummary;
  }
}

String getDayName(DateTime dateTime) {
  switch (dateTime.weekday) {
    case 1:
      return 'Mon';
    case 2:
      return 'Tue';
    case 3:
      return 'Wed';
    case 4:
      return 'Thu';
    case 5:
      return 'Fri';
    case 6:
      return 'Sat';
    case 7:
      return 'Sun';
    default:
      return 'nan';
  }
}




