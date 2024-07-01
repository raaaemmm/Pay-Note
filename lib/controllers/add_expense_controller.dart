import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pay_note/controllers/current_user_controller.dart';
import 'package:pay_note/controllers/state_controller.dart';
import 'package:pay_note/controllers/transaction_controller.dart';
import 'package:pay_note/models/transaction_model.dart';
import 'package:pay_note/models/category_model.dart';
import 'package:pay_note/services/transaction_service.dart';

class AddExpenseController extends GetxController {
  final TransactionService _transactionService = TransactionService();
  final _userController = Get.put(CurrentUserController());
  final _transactionController = Get.put(TransactionController());
  final _stateController = Get.put(StateController());

  List<TransactionModel> transactions = [];

  final expenseDescription = TextEditingController();
  final expenseAmount = TextEditingController();
  final expenseDate = TextEditingController();
  final expenseCategory = TextEditingController();
  final expenseFormKey = GlobalKey<FormState>();

  final newCategoryController = TextEditingController();
  final categoryFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isAdding = false;

  List<String> currencyOptions = [
    'usd',
    'riel',
  ];
  String selectedCurrency = 'usd';

  List<String> categoryOptions = [];
  List<String> defaultCategories = [
    'food & dining',
    'transportation',
    'entertainment',
    'healthcare',
    'others',
  ];

  @override
  void onInit() {
    getUserCategories();
    super.onInit();
  }

  void setSelectedCurrency(String currency) {
    selectedCurrency = currency;
    update();
  }


  void clearExpense() {
    expenseAmount.clear();
    expenseCategory.clear();
    expenseDate.clear();
    expenseDescription.clear();
  }

  Future<void> addTransaction({
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
      await _transactionService.addTransaction(
        description: description,
        userId: userId,
        amount: amount,
        date: date,
        currencyType: selectedCurrency,
        type: type,
        category: category,
      );

      _transactionController.getTransactionsForSelectedDate();
      _stateController.fetchTransactionsByMonthAndYear();
      clearExpense();
      Get.back();

      showMessage('transaction added successfully'.tr, Colors.green);
    } catch (e) {
      print('Error adding transaction: $e');
      showMessage('failed to add transaction. please try again'.tr, Colors.red);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> addNewCategory({
    required String newCategory,
  }) async {
    try {
      isAdding = true;
      update();

      await _transactionService.addCategoryToUserFirestore(
        userId: _userController.currentUser!.id.toString(),
        category: newCategory,
        type: 'Expense',
      );

      categoryOptions.add(newCategory);

      showMessage('category added successfully'.tr, Colors.blue.shade900);
    } catch (e) {
      print('Error adding category: $e');
      showMessage('failed to add category. please try again'.tr, Colors.red);
    } finally {
      isAdding = false;
      update();
    }
  }

  Future<void> getUserCategories() async {
    try {
      List<CategoryModel> userCategories = await _transactionService.getUserCategories(
        userId: _userController.currentUser!.id.toString(),
        type: 'Expense',
      );

      categoryOptions.clear();
      categoryOptions.addAll(userCategories.map((category) => category.categoryName));

      for (var defaultCategory in defaultCategories) {
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
    expenseDescription.dispose();
    expenseAmount.dispose();
    expenseDate.dispose();
    expenseCategory.dispose();
    newCategoryController.dispose();
    super.onClose();
  }
}
