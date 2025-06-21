import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Expense {
  String title;
  double amount;
  String time;
  String date;

  Expense({required this.title, required this.amount, required this.time, required this.date});
}

class DashboardController extends GetxController {
  var expenseTotal = 0.0.obs;
  List<Expense> allExpenses = [];
  List<Expense> filteredExpenses = [];
  DateTime selectedDate = DateTime.now();
  double todayTotal = 0;
  bool get isTodaySelected => DateTime.now().day == selectedDate.day;

  @override
  void onInit() {
    loadSavedDate();
    loadExpenses();
    super.onInit();
  }

  void loadSavedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString('last_date');
    if (lastDate != null) selectedDate = DateTime.parse(lastDate);
  }

  void pickDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate = picked;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('last_date', picked.toIso8601String());
      loadExpenses();
    }
  }

  void loadExpenses() {
    filteredExpenses = allExpenses.where((e) => e.date == DateFormat('yyyy-MM-dd').format(selectedDate)).toList();
    todayTotal = filteredExpenses.fold(0, (sum, e) => sum + e.amount);
    expenseTotal.value = todayTotal;
    update(['expenseList']);
  }

  // void addExpense() {
  //   final now = DateTime.now();
  //   final newExpense = Expense(
  //     title: 'New Expense',
  //     amount: 100,
  //     time: DateFormat('HH:mm').format(now),
  //     date: DateFormat('yyyy-MM-dd').format(now),
  //   );
  //   allExpenses.add(newExpense);
  //   loadExpenses();
  // }
  void addExpense() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    await showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String title = titleController.text.trim();
                double? amount = double.tryParse(amountController.text.trim());

                if (title.isNotEmpty && amount != null) {
                  final now = DateTime.now();
                  final newExpense = Expense(
                    title: title,
                    amount: amount,
                    time: DateFormat('HH:mm').format(now),
                    date: DateFormat('yyyy-MM-dd').format(now),
                  );
                  allExpenses.add(newExpense);
                  loadExpenses();
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar("Error", "Please enter valid title and amount");
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // void editExpense(int index) {
  //   allExpenses[index].title = 'Edited';
  //   loadExpenses();
  // }

  void deleteExpense(int index) {
    allExpenses.removeAt(index);
    loadExpenses();
  }
  void editExpense(int index) async {
    final expense = allExpenses[index];
    final titleController = TextEditingController(text: expense.title);
    final amountController = TextEditingController(text: expense.amount.toString());

    await showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String newTitle = titleController.text.trim();
                double? newAmount = double.tryParse(amountController.text.trim());

                if (newTitle.isNotEmpty && newAmount != null) {
                  allExpenses[index].title = newTitle;
                  allExpenses[index].amount = newAmount;
                  loadExpenses();
                }

                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

}