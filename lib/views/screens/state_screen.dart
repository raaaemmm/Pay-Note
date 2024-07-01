import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pay_note/controllers/state_controller.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';
import 'package:pie_chart/pie_chart.dart'; // Add this import

class StateScreen extends StatelessWidget {
  StateScreen({super.key});

  final _themeModeController = Get.put(ThemeModeController());
  final _stateController = Get.put(StateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeModeController.isDark ? Colors.transparent : Theme.of(context).primaryColor,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'state'.tr,
          style: GoogleFonts.kantumruyPro(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          GetBuilder<StateController>(
            builder: (_) {
              // format selected month
              String formattedDate = _stateController.selectedDate.month == DateTime.now().month && _stateController.selectedDate.year == DateTime.now().year
                  ? 'this month'.tr
                  : DateFormat('MM/yyyy').format(_stateController.selectedDate);

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // back previous month
                    GestureDetector(
                      onTap: () {
                        _stateController.goToPreviousMonth();
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: _themeModeController.isDark
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
                    ),

                    // choose month
                    GestureDetector(
                      onTap: () {
                        _stateController.chooseMonth(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: _themeModeController.isDark
                              ? Colors.white.withOpacity(0.1)
                              : Theme.of(context).primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: _themeModeController.isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          formattedDate,
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

                    // go to next month
                    GestureDetector(
                      onTap: () {
                        _stateController.goToNextMonth();
                      },
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: _themeModeController.isDark
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: GetBuilder<StateController>(
              builder: (_) {

                double totalIncome = _stateController.getTotalAmountByDateAndTypeInUSD('Income');
                double totalExpenses = _stateController.getTotalAmountByDateAndTypeInUSD('Expense');
                double balance = totalIncome - totalExpenses;

                if (_stateController.isLoading) {
                  return Center(
                    child: LoadingAnimationWidget.prograssiveDots(
                      color: _themeModeController.isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      size: 25.0,
                    ),
                  );
                } else if (_stateController.transactions.isEmpty) {
                  return Center(
                    child: Text(
                      'no transactions yet'.tr,
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 15.0,
                        color: Colors.pink,
                      ),
                    ),
                  );
                } else {
                  Map<String, Map<String, double>> categoryTotals = _stateController.getTotalAmountByCategoriesForBothTypes();

                  Map<String, double> expenseData = categoryTotals['Expense']!;
                  Map<String, double> incomeData = categoryTotals['Income']!;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 350.0,
                              // height: 350.0,
                              child: PieChart(
                                dataMap: {
                                  ...expenseData.map((key, value) => MapEntry(key.tr, value)),
                                  ...incomeData.map((key, value) => MapEntry(key.tr, value)),
                                },
                                // colorList: [
                                //   Colors.pink,
                                //   Theme.of(context).primaryColor,
                                // ],
                                centerWidget: Column(
                                  children: [
                                    Text(
                                      'Income: \$ ${totalIncome.toStringAsFixed(2)}',
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Expense: \$ ${totalExpenses.toStringAsFixed(2)}',
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                chartType: ChartType.disc,
                                chartValuesOptions: ChartValuesOptions(
                                  chartValueBackgroundColor: Colors.white,
                                  showChartValuesInPercentage: true,
                                  showChartValues: true,
                                  decimalPlaces: 2,
                                  showChartValueBackground: true,
                                  showChartValuesOutside: false,
                                  chartValueStyle: GoogleFonts.kantumruyPro(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            /*
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 15.0,
                                      width: 15.0,
                                      decoration: const BoxDecoration(
                                        color: Colors.pink,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 15.0),
                                    Text(
                                      '${'expense'.tr} (\$)',
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 15.0,
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 15.0,
                                      width: 15.0,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 15.0),
                                    Text(
                                      '${'income'.tr} (\$)',
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 15.0,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            */
                          ],
                        ),
                      ),
                      Expanded(
                        child: GetBuilder<StateController>(
                          builder: (_) {
                            return RefreshIndicator(
                              onRefresh: () async {
                                await _stateController.fetchTransactionsByMonthAndYear();
                              },
                              color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(15.0),
                                physics: const BouncingScrollPhysics(),
                                itemCount: expenseData.length + incomeData.length,
                                itemBuilder: (context, index) {
                                  bool isExpense = index < expenseData.length;
                                  String category = isExpense
                                      ? expenseData.keys.elementAt(index)
                                      : incomeData.keys.elementAt(index - expenseData.length);
                                  double amount = isExpense
                                      ? expenseData[category]!
                                      : incomeData[category]!;
                              
                                  return Slidable(
                                    endActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      dragDismissible: true,
                                      children: [
                                        SlidableAction(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                          ),
                                          autoClose: true,
                                          onPressed: (context) {
                                            _stateController.deleteTransactionsByCategory(category: category);
                                          },
                                          icon: Icons.delete,
                                          backgroundColor: _themeModeController.isDark
                                              ? Colors.white.withOpacity(0.1)
                                              : Colors.pink,
                                          foregroundColor: Colors.white,
                                          label: 'delete'.tr,
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      elevation: 0,
                                      color: _themeModeController.isDark
                                          ? Colors.white.withOpacity(0.1)
                                          : Theme.of(context).primaryColor.withOpacity(0.1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          category.tr,
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: _themeModeController.isDark
                                                ? Colors.white
                                                : Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        trailing: Text(
                                          isExpense
                                              ? '- \$ ${amount.toStringAsFixed(2)}'
                                              : '+ \$ ${amount.toStringAsFixed(2)}',
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: isExpense
                                                ? Colors.pink
                                                : _themeModeController.isDark
                                                    ? Colors.white
                                                    : Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'income'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: _themeModeController.isDark
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  '\$ ${totalIncome.toStringAsFixed(2)}',
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: _themeModeController.isDark
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'expense'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  ),
                                ),
                                Text(
                                  '\$ ${totalExpenses.toStringAsFixed(2)}',
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'balance'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: _themeModeController.isDark
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  '\$ ${balance.toStringAsFixed(2)}',
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: _themeModeController.isDark
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
