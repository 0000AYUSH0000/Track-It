import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_it/components/daily_expense_summary.dart';
import 'package:track_it/components/expense_tile.dart';
import 'package:track_it/components/monthly_expense_summary.dart';
import 'package:track_it/data/expense_data.dart';
import 'package:track_it/date_time/date_time_helper.dart';
import 'package:track_it/models/expense_item.dart';
import 'package:track_it/pages/analytics_page.dart';
import '../animation/page_transition.dart';
import '../components/category_selection.dart';
import '../components/segmented_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  final newExpenseCategoryController = TextEditingController();
  String selectedSummary = 'Weekly';
  String selectedCategory = "";

  void _onSelectionChanged(Set<String> newSelection) {
    setState(() {
      selectedSummary = newSelection.first;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseData>(context, listen: false).prepareData();
    });
  }

  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              scrollable: true,
              title: const Text(
                'Add New Expense',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration:
                        const InputDecoration(hintText: "Expense Title"),
                    controller: newExpenseNameController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(hintText: "Expense Amount"),
                    controller: newExpenseAmountController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CategorySelector(
                    onCategorySelected: (category) {
                      selectedCategory = category; // Update selected category
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent, // Background color
                  ),
                  onPressed: cancelExpense,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, // Background color
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ));
  }

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void saveExpense() {
    ExpenseItem expenseItem = ExpenseItem(
        name: newExpenseNameController.text.trim(),
        amount: double.parse(newExpenseAmountController.text.trim()),
        dateTime: DateTime.now(),
        category: selectedCategory,
        categoryIcon: 'assets/${selectedCategory.toLowerCase()}.png');

    Provider.of<ExpenseData>(context, listen: false).addNewExpense(expenseItem);
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
    Navigator.pop(context);
  }

  void cancelExpense() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
    newExpenseCategoryController.clear();
    Navigator.pop(context);
  }

  void editExpense(BuildContext context, ExpenseItem expense) {
    var editExpenseController = TextEditingController(text: expense.name);
    var editAmountController =
        TextEditingController(text: expense.amount.toString());
    String currentSelectedCategory = expense.category;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              scrollable: true,
              title: const Text(
                'Edit Expense',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration:
                        const InputDecoration(hintText: "Expense Title"),
                    controller: editExpenseController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(hintText: "Expense Amount"),
                    controller: editAmountController,
                  ),
                  CategorySelector(
                    onCategorySelected: (category) {
                      currentSelectedCategory =
                          category; // Update selected category
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent, // Background color
                  ),
                  onPressed: cancelExpense,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, // Background color
                  ),
                  onPressed: () {
                    Provider.of<ExpenseData>(context, listen: false).editExpense(
                        editExpenseController.text.trim(),
                        double.parse(editAmountController.text.trim()),
                        expense.dateTime,
                        currentSelectedCategory,
                        'assets/${currentSelectedCategory.toLowerCase()}.png');
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black87,
            onPressed: addNewExpense,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SegmentButton(
                      selected: {selectedSummary},
                      segments: const <Segment>[
                        Segment(
                          value: 'Weekly',
                          label: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Daily',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Segment(
                          value: 'Monthly',
                          label: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Monthly',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                      onSelectionChanged: _onSelectionChanged,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(createPageRoute(const AnalyticsPage()));
                      },
                      icon: const Icon(
                        Icons.analytics_outlined,
                        size: 38,
                      ))
                ],
              ),
              const SizedBox(height: 20),
              selectedSummary == 'Weekly'
                  ? ExpenseSummary(startOfTheWeek: value.startOfWeekDate()!)
                  : MonthlyExpenseSummary(
                      monthlySummary: value.monthlyExpenseSummary(),
                    ),
              const SizedBox(
                height: 45,
              ),
              value.getAllExpenseList().isEmpty
                  ? const Center(
                      child: Text(
                        'No Expenses as of now...',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 23),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.getAllExpenseList().length,
                      itemBuilder: (context, index) {
                        DateTime dateTime =
                            value.getAllExpenseList()[index].dateTime;
                        String convertedDateTime = convert(dateTime);
                        String expenseName =
                            value.getAllExpenseList()[index].name;
                        double expenseAmount =
                            value.getAllExpenseList()[index].amount;
                        String expenseCategory =
                            value.getAllExpenseList()[index].category;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0 ||
                                convert(value
                                        .getAllExpenseList()[index - 1]
                                        .dateTime) !=
                                    convertedDateTime)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 10),
                                child: Text(
                                  convertedDateTime,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ExpenseTile(
                              editTapped: (context) => editExpense(
                                  context, value.getAllExpenseList()[index]),
                              deleteTapped: (context) => deleteExpense(
                                  value.getAllExpenseList()[index]),
                              expenseName: expenseName,
                              expenseAmount: expenseAmount,
                              dateTime: convertedDateTime,
                              category: expenseCategory,
                            ),
                            const Divider(), // Add a divider between items
                          ],
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}
