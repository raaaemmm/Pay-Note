import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pay_note/controllers/current_user_controller.dart';
import 'package:pay_note/controllers/state_controller.dart';
import 'package:pay_note/controllers/transaction_controller.dart';
import 'package:pay_note/models/category_model.dart';
import 'package:pay_note/models/transaction_model.dart';
import 'package:pay_note/services/transaction_service.dart';

class UpdateTransactionController extends GetxController {
  final _transactionService = TransactionService();
  final _transactionController = Get.put(TransactionController());
  final _userController = Get.put(CurrentUserController());
  final _stateController = Get.put(StateController());

  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  List<String> currencyOptions = [
    'usd',
    'riel',
  ];
  String selectedCurrency = 'use';

  List<String> categoryOptions = [];
  List<String> defaultCatories = [
    'food & dining',
    'transportation',
    'entertainment',
    'healthcare',
    'salary',
    'freelance',
    'investment',
    'sale',
    'others',
  ];

  void setSelectedCurrency(String currency) {
    selectedCurrency = currency;
    update();
  }

  void clearText() {
    amountController.clear();
    categoryController.clear();
    dateController.clear();
    descriptionController.clear();
  }

  void initFormFields(TransactionModel transaction) {
    amountController.text = transaction.amount.toString();
    selectedCurrency = transaction.currencyType ?? 'USD';
    categoryController.text = transaction.category?.tr ?? '';
    dateController.text = DateFormat('dd/MM/yyyy').format(transaction.date!);
    descriptionController.text = transaction.description ?? '';
    update();
  }

  Future<void> editTransaction(String id, {
    required String description,
    required double amount,
    required DateTime date,
    required String type,
    required String category,
  }) async {
    try {
      isLoading = true;
      update();
      String userId = _userController.currentUser!.id.toString();
      
      // Update transaction in the service
      await _transactionService.updateTransaction(
        userId,
        id,
        description: description,
        amount: amount,
        date: date,
        type: type,
        currencyType: selectedCurrency,
        category: category,
      );

      clearText();
      update();

      // Fetch updated transactions for selected date
      _transactionController.getTransactionsForSelectedDate();
      _stateController.fetchTransactionsByMonthAndYear();
      Get.back();

      showMessage('transaction updated successfully'.tr, Colors.green);
    } catch (e) {
      print('Error editing transaction: $e');
      showMessage('failed to update transaction. please try again'.tr, Colors.red);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getUserCategories(String transactionType) async {
    try {
      List<CategoryModel> userCategories = await _transactionService.getUserCategories(
        userId: _userController.currentUser!.id.toString(),
        type: transactionType,
      );
      // Extract category names from user categories
      categoryOptions.clear();
      categoryOptions.addAll(userCategories.map((category) => category.categoryName));

      // Add default categories that are not already in user categories
      for (var defaultCategory in defaultCatories) {
        if (!categoryOptions.contains(defaultCategory)) {
          categoryOptions.add(defaultCategory);
        }
      }
      update();
    } catch (e) {
      print('Error fetching user categories: $e');
    }
  }

  Future<void> pickDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      helpText: 'select date'.tr,
      cancelText: 'cancel'.tr,
      confirmText: 'ok'.tr,
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            textTheme: TextTheme(

              // Help text style
              headlineMedium: GoogleFonts.kantumruyPro(
                fontSize: 15.0,
                fontWeight:FontWeight.bold,
              ),

              // Confirm button text style
              labelLarge: GoogleFonts.kantumruyPro(
                fontSize: 15.0,
                fontWeight:FontWeight.bold,
              ),
              bodyLarge: GoogleFonts.kantumruyPro(
                fontSize: 15.0,
                // fontWeight:FontWeight.bold,
              ),
              bodyMedium: GoogleFonts.kantumruyPro(
                fontSize: 15.0,
                fontWeight:FontWeight.bold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
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

  @override
  void onClose() {
    // Dispose controllers to avoid memory leaks
    descriptionController.dispose();
    amountController.dispose();
    dateController.dispose();
    categoryController.dispose();
    super.onClose();
  }
}
