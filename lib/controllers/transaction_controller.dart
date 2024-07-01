import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pay_note/controllers/current_user_controller.dart';
import 'package:pay_note/controllers/state_controller.dart';
import 'package:pay_note/models/transaction_model.dart';
import 'package:pay_note/services/transaction_service.dart';

class TransactionController extends GetxController {
  final _transactionService = TransactionService();
  final _userController = Get.put(CurrentUserController());
  final _stateController = Get.put(StateController());

  List<TransactionModel> transactions = [];

  bool isLoading = false;
  bool isAdding = false;
  bool isDeleting = false;
  int defaultIndex = 0;
  DateTime selectedDate = DateTime.now();

  List types = [
    'expense',
    'income',
  ];

  @override
  void onInit() {
    super.onInit();
    getTransactionsForSelectedDate();
  }

  void selectedIndex(int index) {
    defaultIndex = index;
    update();
  }

  // Helper method to check if two dates are the same day
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  // New method to get total amount by date, type, and currency
  double getTotalAmountByDateTypeAndCurrency(String type, String currencyType) {
    double total = 0.0;
    for (var transaction in transactions) {
      if (isSameDate(transaction.date!, selectedDate) && transaction.type == type && transaction.currencyType == currencyType) {
        total += transaction.amount ?? 0.0;
      }
    }
    return total;
  }

  // get transaction by categories
  Future<void> getTransactionsByCategory({
    required String category,
    required String transactionType,
  }) async {
    try {
      isLoading = true;
      update();

      transactions = await _transactionService.getTransactionsByCategory(
        userId: _userController.currentUser!.id.toString(),
        category: category,
        type: transactionType, // or 'Income' based on your needs
      );

    } catch (e) {
      print('Error fetching transactions by category: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  // get transaction by selected date
  Future<void> getTransactionsForSelectedDate() async {
    try {
      isLoading = true;
      update();

      print("Fetching transactions for date: ${selectedDate.toIso8601String()}");
      transactions = await _transactionService.getTransactionsByDate(
        _userController.currentUser!.id.toString(),
        selectedDate,
      );
      print("Transactions fetched: 👉 ${transactions.length}");
    } catch (e) {
      print('Error fetching transactions by date: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      isDeleting = true;
      update();
      
      String userId = _userController.currentUser!.id.toString();
      await _transactionService.deleteTransaction(userId, id);
      transactions.removeWhere((tx) => tx.id == id);

      _stateController.fetchTransactionsByMonthAndYear();
      update();

      showMessage('transaction deleted successfully'.tr, Colors.green);
    } catch (e) {
      print('Error deleting transaction: $e');
      showMessage('failed to delete transaction. please try again'.tr, Colors.red);
    } finally {
      isDeleting = false;
      update();
    }
  }

  void showMessage(String msg, Color color) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void goToPreviousDate() {
    selectedDate = selectedDate.subtract(const Duration(days: 1));
    getTransactionsForSelectedDate();
  }

  // Method to handle selecting a new date
  void chooseDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
      getTransactionsForSelectedDate();
    }
  }

  void goToNextDate() {
    selectedDate = selectedDate.add(const Duration(days: 1));
    getTransactionsForSelectedDate();
  }
}
