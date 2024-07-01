import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pay_note/controllers/current_user_controller.dart';
import 'package:pay_note/controllers/state_controller.dart';
import 'package:pay_note/controllers/transaction_controller.dart';
import 'package:pay_note/models/category_model.dart';
import 'package:pay_note/services/transaction_service.dart';

class CategoryController extends GetxController {

  final _transactionController = Get.put(TransactionController());
  final _stateController = Get.put(StateController());

  final _transactionService = TransactionService();
  final _userController = Get.put(CurrentUserController());

  // Controllers for text fields
  final updateCategoryController = TextEditingController();
  final newCategoryController = TextEditingController();
  final searchController = TextEditingController();

  // Form key for validation
  final categoryFormKey = GlobalKey<FormState>();

  // Flags for loading states
  bool isUpdating = false;
  bool isLoading = false;
  bool isAdding = false;
  bool isDeleting = false;
  bool isClearText = false;

  // Categories
  List<String> expenseCategoryOptions = [];
  List<String> incomeCategoryOptions = [];

  // Filtered lists for search results
  List<String> searchedExpenseCategories = [];
  List<String> searchedIncomeCategories = [];

  // Default categories
  final List<String> expenseDefaultCategories = [
    'food & dining'.tr,
    'transportation'.tr,
    'entertainment'.tr,
    'healthcare'.tr,
    'others'.tr,
  ];

  final List<String> incomeDefaultCategories = [
    'salary'.tr,
    'freelance'.tr,
    'investment'.tr,
    'sale'.tr,
    'others'.tr,
  ];

  // Map to track dropdown state
  final Map<String, bool> dropdownStates = {
    'expense categories'.tr: true,
    'income categories'.tr: true,
  };

  @override
  void onInit() {
    super.onInit();
    getUserCategories();
  }

  // Method to toggle visibility of clear text button
  void showAndHideClearText(bool isVisible) {
    isClearText = isVisible;
    update();
  }

  // Method to clear search text and list
  void clearTextAndList() {
    searchController.clear();
    searchedExpenseCategories.clear();
    searchedIncomeCategories.clear();
    isClearText = false;
    update();
  }

  // Method to add a new category
  Future<void> addNewCategory({required String newCategory, required String type}) async {
    try {
      isAdding = true;
      update();

      await _transactionService.addCategoryToUserFirestore(
        userId: _userController.currentUser!.id.toString(),
        category: newCategory,
        type: type,
      );

      if (type == 'Expense') {
        expenseCategoryOptions.insert(0, newCategory);
      } else if (type == 'Income') {
        incomeCategoryOptions.insert(0, newCategory);
      }

      showMessage('category added successfully'.tr, Colors.blue.shade900);
    } catch (e) {
      print('Error adding category: $e');
      showMessage('failed to add category. please try again'.tr, Colors.red);
    } finally {
      isAdding = false;
      update();
    }
  }

  // Method to fetch user categories
  Future<void> getUserCategories() async {
    try {
      isLoading = true;
      update();

      List<CategoryModel> expenseCategories = await _transactionService.getUserCategories(
        userId: _userController.currentUser!.id.toString(),
        type: 'Expense',
      );

      expenseCategoryOptions = expenseCategories.map((category) => category.categoryName).toList();
      for (var defaultCategory in expenseDefaultCategories) {
        if (!expenseCategoryOptions.contains(defaultCategory)) {
          expenseCategoryOptions.add(defaultCategory);
        }
      }

      List<CategoryModel> incomeCategories = await _transactionService.getUserCategories(
        userId: _userController.currentUser!.id.toString(),
        type: 'Income',
      );

      incomeCategoryOptions = incomeCategories.map((category) => category.categoryName).toList();
      for (var defaultCategory in incomeDefaultCategories) {
        if (!incomeCategoryOptions.contains(defaultCategory)) {
          incomeCategoryOptions.add(defaultCategory);
        }
      }

      update();
    } catch (e) {
      print('Error fetching user categories: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  // Method to delete a category
  Future<void> deleteCategory({required String category, required String type}) async {
    try {
      if (type == 'Expense' && expenseDefaultCategories.contains(category)) {
        showMessage('Cannot delete default expense category'.tr, Colors.red);
        return;
      }
      if (type == 'Income' && incomeDefaultCategories.contains(category)) {
        showMessage('Cannot delete default income category'.tr, Colors.red);
        return;
      }

      isDeleting = true;
      update();

      await _transactionService.deleteCategory(
        userId: _userController.currentUser!.id.toString(),
        category: category,
        type: type,
      );

      if (type == 'Expense') {
        expenseCategoryOptions.remove(category);
      } else if (type == 'Income') {
        incomeCategoryOptions.remove(category);
      }

      // reload 
      await getUserCategories();
      _stateController.deleteTransactionsByCategory(category: category);
      _transactionController.getTransactionsForSelectedDate();
      _stateController.fetchTransactionsByMonthAndYear();

      showMessage('category deleted successfully'.tr, Colors.blue.shade900);
    } catch (e) {
      print('Error deleting category: $e');
      showMessage('failed to delete category. please try again'.tr, Colors.red);
    } finally {
      isDeleting = false;
      update();
    }
  }

  // Method to update a category
  Future<void> updateCategory({
    required String oldCategory,
    required String newCategory,
    required String type,
  }) async {
    try {
      isUpdating = true;
      update();

      await _transactionService.updateCategory(
        userId: _userController.currentUser!.id.toString(),
        oldCategory: oldCategory,
        newCategory: newCategory,
        type: type,
      );

      if (type == 'Expense') {
        int index = expenseCategoryOptions.indexOf(oldCategory);
        if (index != -1) {
          expenseCategoryOptions[index] = newCategory;
        }
      } else if (type == 'Income') {
        int index = incomeCategoryOptions.indexOf(oldCategory);
        if (index != -1) {
          incomeCategoryOptions[index] = newCategory;
        }
      }

      showMessage('category updated successfully'.tr, Colors.blue.shade900);
    } catch (e) {
      print('Error updating category: $e');
      showMessage('failed to update category. please try again'.tr, Colors.red);
    } finally {
      isUpdating = false;
      update();
    }
  }

  // Method to search all categories
  void searchAllCategories(String query) {
    searchedExpenseCategories = expenseCategoryOptions
        .where((category) => category.toLowerCase().contains(query.toLowerCase()))
        .toList();

    searchedIncomeCategories = incomeCategoryOptions
        .where((category) => category.toLowerCase().contains(query.toLowerCase()))
        .toList();

    update();
  }

  // Method to show a message
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

  // Method to check if a dropdown is expanded
  bool isDropdownExpanded(String title) {
    return dropdownStates[title] ?? false;
  }

  // Method to toggle dropdown expansion
  void toggleDropdownExpansion(String title) {
    dropdownStates[title] = !(dropdownStates[title] ?? false);
    update();
  }

  @override
  void onClose() {
    newCategoryController.dispose();
    searchController.dispose();
    updateCategoryController.dispose();
    super.onClose();
  }
}
