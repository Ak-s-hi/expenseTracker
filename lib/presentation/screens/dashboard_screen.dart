import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/dashboard_controller.dart';
import '../../../routes/app_pages.dart'; // Make sure this path is correct for your routing

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);
  final controller = Get.put(DashboardController());

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoutes.login); // Redirect to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout,color: Colors.white,),
            tooltip: 'Logout',
            onPressed: logout,

          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => Text(
              "Total: ₹${controller.expenseTotal.value.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            )),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.pickDate,
              icon: Icon(Icons.calendar_today),
              label: Text("Select Date"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GetBuilder<DashboardController>(
                id: 'expenseList',
                builder: (_) => controller.filteredExpenses.isEmpty
                    ? Center(
                  child: Text(
                    "No expenses found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: controller.filteredExpenses.length,
                  itemBuilder: (_, index) {
                    final expense = controller.filteredExpenses[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          expense.title,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text("₹${expense.amount} • ${expense.time}"),
                        trailing: controller.isTodaySelected
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => controller.editExpense(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.deleteExpense(index),
                            ),
                          ],
                        )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: controller.isTodaySelected
          ? FloatingActionButton(
        onPressed: controller.addExpense,
        backgroundColor: Colors.teal,
        child: Icon(Icons.add,color: Colors.white,),
      )
          : null,
    );
  }
}
