import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pay_note/controllers/current_user_controller.dart';
import 'package:pay_note/models/transaction_model.dart';
import 'package:pay_note/services/transaction_service.dart';

class ExcelController extends GetxController {

  final _transactionService = TransactionService();
  final _userController = Get.put(CurrentUserController());

  List<TransactionModel> transactions = [];
  bool isLoading = false;
  bool isExporting = false;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  // get all transactions
  Future<void> fetchTransactions() async {
    try {
      isLoading = true;
      update();

      transactions = await _transactionService.getAllTransactions(
        _userController.currentUser!.id.toString(),
      );
      print('Fetched transactions: ${transactions.length}');

    } catch (e) {
      print('Error fetching transactions: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  // export data into excel file
  Future<bool> exportTransactionsToExcel() async {
    try {
      isExporting = true;
      update();

      // create a new Excel workbook
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      // headers
      sheet.getRangeByIndex(1, 1).setText('TR-ID');
      sheet.getRangeByIndex(1, 2).setText('Description');
      sheet.getRangeByIndex(1, 3).setText('Amount');
      sheet.getRangeByIndex(1, 4).setText('Date');
      sheet.getRangeByIndex(1, 5).setText('Currency-Type');
      sheet.getRangeByIndex(1, 6).setText('Type');
      sheet.getRangeByIndex(1, 7).setText('Category');

      // data rows
      int rowIndex = 2;
      for (var transaction in transactions) {
        sheet.getRangeByIndex(rowIndex, 1).setText(transaction.id ?? '');
        sheet.getRangeByIndex(rowIndex, 2).setText(transaction.description ?? '');
        sheet.getRangeByIndex(rowIndex, 3).setNumber(transaction.amount ?? 0.0);
        sheet.getRangeByIndex(rowIndex, 4).setDateTime(transaction.date ?? DateTime.now());
        sheet.getRangeByIndex(rowIndex, 5).setText(transaction.currencyType?.toUpperCase() ?? '');
        sheet.getRangeByIndex(rowIndex, 6).setText(transaction.type ?? '');
        sheet.getRangeByIndex(rowIndex, 7).setText(transaction.category?.toUpperCase() ?? '');
        rowIndex++;
      }

      // save the Excel file
      final List<int> bytes = workbook.saveAsStream();
      final String path = (await getExternalStorageDirectory())!.path;
      final String fileName = '$path/transactions.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);

      print('Excel file exported successfully');

      // share the Excel file
      await Share.shareXFiles(
        [XFile(fileName)],
        text: 'Exported all transactions in account: ${_userController.currentUser!.email?? ''}',
      );
      return true;
    } catch (e) {
      print('Error exporting Excel file: $e');
      return false;
    } finally {
      isExporting = false;
      update();
    }
  }
}
