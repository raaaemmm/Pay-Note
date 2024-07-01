import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';
import 'package:pay_note/controllers/update_transaction_controller.dart';
import 'package:pay_note/models/transaction_model.dart';

class UpdateTransactionScreen extends StatelessWidget {
  UpdateTransactionScreen({super.key, required this.transaction});

  final TransactionModel transaction;
  final _themeModeController = Get.put(ThemeModeController());
  final _updateController = Get.put(UpdateTransactionController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        body: GetBuilder<UpdateTransactionController>(
          initState: (state) {
            _updateController.initFormFields(transaction);
            _updateController.getUserCategories(transaction.type.toString());
          },
          builder: (_) {
            return Form(
              key: _updateController.formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [

                    // center dot
                    const SizedBox(height: 15.0),
                    Center(
                      child: Container(
                        height: 5.0,
                        width: MediaQuery.of(context).size.width / 3.5,
                        decoration: BoxDecoration(
                          color: _themeModeController.isDark
                              ? Colors.white.withOpacity(0.1)
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),

                    // amount & currency form | type USD(USA) or Riel(KH)
                    const SizedBox(height: 40.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _updateController.amountController,
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
                            iconEnabledColor: _themeModeController.isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            value: _updateController.selectedCurrency,
                            onChanged: (value) {
                              _updateController.setSelectedCurrency(value!);
                            },
                            items: _updateController.currencyOptions.map((String currency) {
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
                      controller: _updateController.categoryController,
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
                          child: PopupMenuButton<String>(
                            color: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: _themeModeController.isDark
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            itemBuilder: (context) {
                              return _updateController.categoryOptions.map((String category) {
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
                              _updateController.categoryController.text = selectedCategory.tr;
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
                      controller: _updateController.dateController,
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
                            _updateController.pickDate(_updateController.dateController);
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
                      controller: _updateController.descriptionController,
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

                    // update button
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        if (_updateController.formKey.currentState!.validate()) {
                          final dateString = _updateController.dateController.text;
                          final parsedDate = DateFormat('dd/MM/yyyy').parseStrict(dateString);

                          String category = _updateController.categoryController.text;
                    
                          // Check if the selected category is in the default list
                          if (_updateController.defaultCatories.map((cat) => cat.toLowerCase()).contains(category.toLowerCase())) {
                            category = category.toLowerCase();
                          }

                          await _updateController
                              .editTransaction(
                                transaction.id!,
                                description: _updateController.descriptionController.text,
                                amount: double.parse(_updateController.amountController.text),
                                date: parsedDate,
                                type: transaction.type!,
                                category: category,
                              );
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
                        child: _updateController.isLoading
                            ? LoadingAnimationWidget.prograssiveDots(
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                size: 25.0,
                              )
                            : Text(
                                transaction.type == 'Expense' ? 'update expense'.tr : 'update income'.tr,
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
