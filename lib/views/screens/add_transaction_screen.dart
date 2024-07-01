import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';
import 'package:pay_note/controllers/transaction_controller.dart';
import 'package:pay_note/views/screens/add_expense_form.dart';
import 'package:pay_note/views/screens/add_income_form.dart';

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({super.key});

  final _themeModeController = Get.put(ThemeModeController());
  final _transactionController = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        body: GetBuilder<TransactionController>(
          builder: (_) => SingleChildScrollView(
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

                // list types
                const SizedBox(height: 40.0),
                Row(
                  children: List.generate(
                    _transactionController.types.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _transactionController.selectedIndex(index);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: _transactionController.defaultIndex == index
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.horizontal(
                              left: index == 0
                                  ? const Radius.circular(10.0)
                                  : Radius.zero,
                              right: index == _transactionController.types.length - 1
                                  ? const Radius.circular(10.0)
                                  : Radius.zero,
                            ),
                          ),
                          child: Text(
                            '${_transactionController.types[index]}'.tr,
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: _transactionController.defaultIndex == index
                                ? Colors.white
                                : _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // expense and income form screen
                const SizedBox(height: 20.0),
                GetBuilder<TransactionController>(
                  builder: (_) {
                    if(_transactionController.defaultIndex == 0){
                      return AddExpenseForm();
                    } else {
                      return AddIncomeForm();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
