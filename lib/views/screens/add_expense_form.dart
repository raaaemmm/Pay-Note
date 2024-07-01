import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pay_note/controllers/add_expense_controller.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';

class AddExpenseForm extends StatelessWidget {
  AddExpenseForm({super.key});

  final _themeModeController = Get.put(ThemeModeController());
  final _addExpenseController = Get.put(AddExpenseController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddExpenseController>(
      builder: (_) {
        return Form(
          key: _addExpenseController.expenseFormKey,
          child: Column(
            children: [
              // amount & currency form | type USD(USA) or Riel(KH)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _addExpenseController.expenseAmount,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'amount'.tr,
                        hintStyle: GoogleFonts.kantumruyPro(
                          fontSize: 15.0,
                          color: _themeModeController.isDark
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        fillColor: _themeModeController.isDark
                            ? Colors.white.withOpacity(0.1)
                            : Theme.of(context).primaryColor.withOpacity(0.1),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter an amount'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      icon: const Icon(
                        Icons.arrow_drop_down_rounded,
                      ),
                      iconEnabledColor: _themeModeController.isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      value: _addExpenseController.selectedCurrency,
                      onChanged: (value) {
                        _addExpenseController.setSelectedCurrency(value!);
                      },
                      items: _addExpenseController.currencyOptions.map((String currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(
                            currency.tr,
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 15.0,
                              color: _themeModeController.isDark
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: _themeModeController.isDark
                            ? Colors.white.withOpacity(0.1)
                            : Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                ],
              ),

              // category form
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _addExpenseController.expenseCategory,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'category'.tr,
                  hintStyle: GoogleFonts.kantumruyPro(
                    fontSize: 15.0,
                    color: _themeModeController.isDark
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  fillColor: _themeModeController.isDark
                      ? Colors.white.withOpacity(0.1)
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  filled: true,
                  suffixIcon: GestureDetector(
                    onDoubleTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => GetBuilder<AddExpenseController>(
                          builder: (_) {
                            return AlertDialog(
                              title: Text(
                                'add new category'.tr,
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: _themeModeController.isDark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: _addExpenseController.newCategoryController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(15.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: 'enter new category'.tr,
                                      hintStyle: GoogleFonts.kantumruyPro(
                                        fontSize: 15.0,
                                        color: _themeModeController.isDark
                                            ? Colors.white
                                            : Theme.of(context).primaryColor,
                                      ),
                                      fillColor: _themeModeController.isDark
                                          ? Colors.white.withOpacity(0.1)
                                          : Theme.of(context).primaryColor.withOpacity(0.1),
                                      filled: true,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    'cancel'.tr,
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: 15.0,
                                      color: _themeModeController.isDark
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    _addExpenseController.isAdding ? 'adding'.tr : 'add'.tr,
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: 15.0,
                                      color: _themeModeController.isDark
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    String newCategory = _addExpenseController.newCategoryController.text.trim();
                                    if (newCategory.isNotEmpty) {
                                      _addExpenseController.addNewCategory(
                                        newCategory: newCategory,
                                      ).whenComplete((){
                                        _addExpenseController.newCategoryController.clear();
                                        Get.back();
                                      });
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },

                    // show categories
                    child: PopupMenuButton<String>(
                      color: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: _themeModeController.isDark
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
                      itemBuilder: (context) {
                        return _addExpenseController.categoryOptions.map((String category) {
                          return PopupMenuItem<String>(
                            enabled: true,
                            value: category,
                            child: Text(
                              category.tr,
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      onSelected: (selectedCategory) {
                        _addExpenseController.expenseCategory.text = selectedCategory.tr;
                      },
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter a category'.tr;
                  } else {
                    return null;
                  }
                },
              ),

              // date form
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _addExpenseController.expenseDate,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'date'.tr,
                  hintStyle: GoogleFonts.kantumruyPro(
                    fontSize: 15.0,
                    color: _themeModeController.isDark
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  fillColor: _themeModeController.isDark
                      ? Colors.white.withOpacity(0.1)
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _addExpenseController.pickDate(_addExpenseController.expenseDate);
                    },
                    icon: Icon(
                      Icons.date_range_rounded,
                      color: _themeModeController.isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter a date'.tr;
                  }
                  try {
                    DateFormat('dd/MM/yyyy').parseStrict(value);
                  } catch (e) {
                    return 'invalid date format'.tr;
                  }
                  return null;
                },
              ),

              // optional description
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _addExpenseController.expenseDescription,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'any additional notes or descriptions'.tr,
                  hintStyle: GoogleFonts.kantumruyPro(
                    fontSize: 15.0,
                    color: _themeModeController.isDark
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  fillColor: _themeModeController.isDark
                      ? Colors.white.withOpacity(0.1)
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  filled: true,
                ),
                maxLines: 3,
              ),

              // add expense button
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  
                  if (_addExpenseController.expenseFormKey.currentState!.validate()) {
                    final dateString = _addExpenseController.expenseDate.text;
                    final parsedDate = DateFormat('dd/MM/yyyy').parseStrict(dateString);

                    String category = _addExpenseController.expenseCategory.text;
                    
                    // Check if the selected category is in the default list
                    if (_addExpenseController.defaultCategories.map((cat) => cat.toLowerCase()).contains(category.toLowerCase())) {
                      category = category.toLowerCase();
                    }

                    _addExpenseController.addTransaction(
                      description: _addExpenseController.expenseDescription.text,
                      amount: double.parse(_addExpenseController.expenseAmount.text),
                      date: parsedDate,
                      type: 'Expense',
                      category: category,
                    ).whenComplete(() => _addExpenseController.clearExpense());
                  }

                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: _themeModeController.isDark
                        ? Colors.white.withOpacity(0.1)
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: _addExpenseController.isLoading
                      ? LoadingAnimationWidget.prograssiveDots(
                          color: _themeModeController.isDark
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          size: 25.0,
                        )
                      : Text(
                          'add expense'.tr,
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: _themeModeController.isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
