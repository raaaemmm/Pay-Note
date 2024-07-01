import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_note/controllers/current_user_controller.dart';
import 'package:pay_note/controllers/transaction_controller.dart';
import 'package:pay_note/models/transaction_model.dart';
import 'package:pay_note/services/transaction_service.dart';

class StateController extends GetxController {

  final _userController = Get.put(CurrentUserController());
  final _transactionService = TransactionService();

  List<TransactionModel> transactions = [];
  bool isLoading = false;
  bool isDeleting = false;
  
  DateTime selectedDate = DateTime.now();
  List<String> monthOptions = [
    'january', 'february', 'march', 'april', 'may', 'june', 
    'july', 'august', 'september', 'october', 'november', 'december',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchTransactionsByMonthAndYear();
  }

  Future<void> fetchTransactionsByMonthAndYear() async {
    try {
      isLoading = true;
      update();

      transactions = await _transactionService.getTransactionsByMonth(
        userId: _userController.currentUser!.id.toString(),
        month: selectedDate.month,
        year: selectedDate.year,
      );

      isLoading = false;
      update();
    } catch (e) {
      print('Error fetching transactions: $e');
      isLoading = false;
      update();
    }
  }


  Future<void> deleteTransactionsByCategory({required String category}) async {
    try {
      isDeleting = true;
      update();

      await _transactionService.deleteTransactionsByCategory(
        userId: _userController.currentUser!.id.toString(),
        category: category,
      );

      // after deletion, fetch updated transactions
      await fetchTransactionsByMonthAndYear();

      // after deletion, getTransactionsForSelectedDate();
      Get.put(TransactionController()).getTransactionsForSelectedDate();

      print('Deletd transaction by category success...!');
      showMessage('transaction deleted by category successfully'.tr, Colors.green);
    } catch (e) {
      print('Error deleting transactions by category: $e');
      showMessage('failed to delete transaction by category. please try again'.tr, Colors.red);
      isDeleting = false;
      update();
    }
  }

  void chooseMonth(BuildContext context) {

    // Store the current month's index
    int currentMonthIndex = selectedDate.month;

    showMenu<String>(
      color: Theme.of(context).primaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      position: const RelativeRect.fromLTRB(20.0, 95.0, 15.0, 0.0),
      items: monthOptions.map((String month) {

        // Get the index of the month
        int monthIndex = monthOptions.indexOf(month) + 1;

        return PopupMenuItem<String>(
          value: month,
          child: Text(
            month.tr,
            style: GoogleFonts.kantumruyPro(
              fontSize: 15.0,
              fontWeight: monthIndex == currentMonthIndex ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        int monthIndex = monthOptions.indexOf(value) + 1;
        selectedDate = DateTime(selectedDate.year, monthIndex, selectedDate.day);
        fetchTransactionsByMonthAndYear();
      }
    });
  }

  void goToPreviousMonth() {
    selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, selectedDate.day);
    fetchTransactionsByMonthAndYear();
  }

  void goToNextMonth() {
    selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
    fetchTransactionsByMonthAndYear();
  }

  Map<String, Map<String, double>> getTotalAmountByCategoriesForBothTypes() {
    Map<String, Map<String, double>> categoryTotals = {
      'Expense': {},
      'Income': {},
    };

    for (var transaction in transactions) {
      if (transaction.date!.year == selectedDate.year && transaction.date!.month == selectedDate.month) {
        String category = transaction.category!;
        double amount = transaction.amount ?? 0.0;

        if (transaction.currencyType == 'riel') {
          amount /= 4100;
        }

        if (categoryTotals[transaction.type]!.containsKey(category)) {
          categoryTotals[transaction.type]![category] = categoryTotals[transaction.type]![category]! + amount;
        } else {
          categoryTotals[transaction.type]![category] = amount;
        }
      }
    }

    return categoryTotals;
  }

  double getTotalAmountByDateAndTypeInUSD(String type) {
    double totalInUSD = 0.0;
    for (var transaction in transactions) {
      if (transaction.date!.year == selectedDate.year && transaction.date!.month == selectedDate.month) {
        if (transaction.type == type) {
          if (transaction.currencyType == 'usd') {
            totalInUSD += transaction.amount ?? 0.0;
          } else if (transaction.currencyType == 'riel') {
            totalInUSD += (transaction.amount ?? 0.0) / 4100;
          }
        }
      }
    }
    return totalInUSD;
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
}
