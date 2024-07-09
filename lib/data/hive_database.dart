// hive_database.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_item.dart';

class HiveDatabase {
  final _myBox = Hive.box("expense_database");

  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpenseFormatted = [];
    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
        expense.category,
        expense.categoryIcon// Include category in the saved data
      ];
      allExpenseFormatted.add(expenseFormatted);
    }

    _myBox.put("ALL_EXPENSES", allExpenseFormatted);
  }

  List<ExpenseItem> readData() {
    List? savedExpenses = _myBox.get("ALL_EXPENSES");
    savedExpenses ??= [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      double amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];
      String category = savedExpenses[i][3];
      String categoryIcon=savedExpenses[i][4];// Read category from saved data

      ExpenseItem expenseItem = ExpenseItem(
          name: name, amount: amount, dateTime: dateTime, category: category, categoryIcon: categoryIcon);
      allExpenses.add(expenseItem);
    }

    return allExpenses;
  }

  void editData(DateTime dateTime, ExpenseItem updatedExpense) {
    List<ExpenseItem> allExpenses = readData();

    for (int i = 0; i < allExpenses.length; i++) {
      if (allExpenses[i].dateTime == dateTime) {
        allExpenses[i] = updatedExpense;
        break;
      }
    }

    saveData(allExpenses);
  }
}
