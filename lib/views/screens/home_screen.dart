import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';
import 'package:pay_note/controllers/transaction_controller.dart';
import 'package:pay_note/views/screens/add_transaction_screen.dart';
import 'package:pay_note/views/screens/update_transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _themeModeController = Get.put(ThemeModeController());
  final _transactionController = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeModeController.isDark
            ? Colors.transparent
            : Theme.of(context).primaryColor,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'transaction'.tr,
          style: GoogleFonts.kantumruyPro(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color:Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [

          // date
          GetBuilder<TransactionController>(
            builder: (_) {
              String formattedDate = DateFormat('dd/MM/yyyy').format(_transactionController.selectedDate);
              String todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: GetBuilder<TransactionController>(
                  builder: (_) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // previous date
                        GestureDetector(
                          onTap: () {
                            _transactionController.goToPreviousDate();
                          },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: _themeModeController.isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        ),
              
                        // today date
                        GestureDetector(
                          onTap: () {
                            _transactionController.chooseDate(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 10.0,
                            ),
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
                              formattedDate == todayDate ? 'today'.tr : formattedDate,
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
              
                        // next date
                        GestureDetector(
                          onTap: () {
                            _transactionController.goToNextDate();
                          },
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: _themeModeController.isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }
          ),

          // transaction data
          Expanded(
            child: GetBuilder<TransactionController>(
              builder: (_) {
                if (_transactionController.isLoading) {
                  return Center(
                    child: LoadingAnimationWidget.prograssiveDots(
                      color: _themeModeController.isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      size: 25.0,
                    ),
                  );
                } else if (_transactionController.transactions.isEmpty) {
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      
                      // total expense & income
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(15.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            
                                // total expense
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'total expense'.tr,
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.pink,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '-${_transactionController.getTotalAmountByDateTypeAndCurrency('Expense', 'usd')} ${'usd'.tr}',
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            color: Colors.pink,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          '-${_transactionController.getTotalAmountByDateTypeAndCurrency('Expense', 'riel')} ${'riel'.tr}',
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ],
                                    ),
                            
                                  
                                  ],
                                ),
                            
                                // total income
                                const SizedBox(width: 20.0),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'total income'.tr,
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '+${_transactionController.getTotalAmountByDateTypeAndCurrency('Income', 'usd')} ${'usd'.tr}',
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          '+${_transactionController.getTotalAmountByDateTypeAndCurrency('Income', 'riel')} ${'riel'.tr}',
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      

                      // transaction items
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await _transactionController.getTransactionsForSelectedDate();
                          },
                          color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                          child: ListView.builder(
                            physics: const  BouncingScrollPhysics(),
                            itemCount: _transactionController.transactions.length,
                            itemBuilder: (context, index) {

                              final transaction = _transactionController.transactions[index];
                              
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
                                        _transactionController.deleteTransaction(transaction.id ??'');
                                      },
                                      icon: Icons.delete,
                                      backgroundColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Colors.pink,
                                      foregroundColor: Colors.white,
                                      label: 'delete'.tr,
                                    ),
                                    SlidableAction(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                      autoClose: true,
                                      onPressed: (context) {
                                        showModalBottomSheet(
                                          isDismissible: true,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return UpdateTransactionScreen(transaction: transaction);
                                          },
                                        );
                                      },
                                      icon: Icons.edit,
                                      backgroundColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      label: 'update'.tr,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Card(
                                    elevation: 0,
                                    color: _themeModeController.isDark
                                        ? Colors.white.withOpacity(0.1)
                                        : Theme.of(context).primaryColor.withOpacity(0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                        vertical: 10.0,
                                      ),
                                      leading: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                                        child: transaction.currencyType?.toLowerCase() == 'riel'
                                            ? Text(
                                                '៛',
                                                style: GoogleFonts.kantumruyPro(
                                                  fontSize: 25.0,
                                                  color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                                ),
                                              )
                                            : Icon(
                                                transaction.type == 'Expense' ? Icons.money_off : Icons.attach_money,
                                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                              ),
                                      ),
                                      title: Text(
                                        '${transaction.category?.tr}',
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: _themeModeController.isDark
                                              ? Colors.white
                                              : Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      subtitle: transaction.description != null && transaction.description!.isNotEmpty
                                          ? Text(
                                              transaction.description!,
                                              style: GoogleFonts.kantumruyPro(
                                                fontSize: 15.0,
                                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                              ),
                                            )
                                          : null,
                                      trailing: Text(
                                        '${transaction.type == 'Expense' ? ' - ' : ' + '}${transaction.amount?.toStringAsFixed(2)} ${transaction.currencyType?.tr}',
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: transaction.type == 'Expense' ? Colors.pink : _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor,
        onPressed: () {
          showModalBottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return FocusScope(child: AddTransactionScreen());
            },
          );
        },
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
