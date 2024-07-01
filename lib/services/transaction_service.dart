import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pay_note/models/category_model.dart';
import 'package:pay_note/models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add transaction
  Future<void> addTransaction({
    required String userId,
    required String description,
    required double amount,
    required DateTime date,
    required String currencyType,
    required String type,
    required String category,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).collection('transactions').add({
        'description': description,
        'amount': amount,
        'date': date.toIso8601String(),
        'currencyType': currencyType,
        'type': type,
        'category': category,
      });
    } catch (e) {
      print('Error adding transaction: $e');
      throw e;
    }
  }

  // Update transaction
  Future<void> updateTransaction(
    String userId,
    String id, {
    required String description,
    required double amount,
    required DateTime date,
    required String type,
    required String currencyType,
    required String category,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).collection('transactions').doc(id).update({
        'description': description,
        'amount': amount,
        'date': date.toIso8601String(),
        'type': type,
        'currencyType': currencyType,
        'category': category,
      });
    } catch (e) {
      print('Error updating transaction: $e');
      throw e;
    }
  }

  // Delete transactions by category
  Future<void> deleteTransactionsByCategory({
    required String userId,
    required String category,
  }) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where('category', isEqualTo: category)
          .get();

      List<Future<void>> deleteFutures = [];
      for (var doc in snapshot.docs) {
        deleteFutures.add(doc.reference.delete());
      }

      await Future.wait(deleteFutures);
    } catch (e) {
      print('Error deleting transactions by category: $e');
      throw e;
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(String userId, String id) async {
    try {
      await _firestore.collection('users').doc(userId).collection('transactions').doc(id).delete();
    } catch (e) {
      print('Error deleting transaction: $e');
      throw e;
    }
  }
  
  // Delete all transactions associated with a user
  Future<void> deleteAllTransactions({required String userId}) async {
    try {
      final collection = _firestore.collection('users').doc(userId).collection('transactions');
      final snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting all transactions: $e');
      throw e;
    }
  }

  // Get all transactions
  Future<List<TransactionModel>> getAllTransactions(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching all transactions: $e');
      throw e;
    }
  }

  // Get transactions by category and type (Expense or Income)
  Future<List<TransactionModel>> getTransactionsByCategory({
    required String userId,
    required String category,
    required String type,
  }) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where('category', isEqualTo: category)
          .where('type', isEqualTo: type)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching transactions by category and type: $e');
      throw e;
    }
  }


  // Get transactions by date
  Future<List<TransactionModel>> getTransactionsByDate(
      String userId, DateTime date) async {
    try {
      DateTime startDate = DateTime(date.year, date.month, date.day, 0, 0, 0);
      DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching transactions by date: $e');
      throw e;
    }
  }

  // Get transactions by month
  Future<List<TransactionModel>> getTransactionsByMonth({
    required String userId,
    required int month, required int year,
  }) async {
    try {
      DateTime now = DateTime.now();
      int year = now.year;

      DateTime startDate = DateTime(year, month, 1);
      DateTime endDate = DateTime(year, month + 1, 0);

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching transactions by month: $e');
      throw e;
    }
  }

  // Get transactions by month and year
  Future<List<TransactionModel>> getTransactionsByMonthAndYear({
    required String userId,
    required int month,
    required int year,
  }) async {
    try {
      DateTime startDate = DateTime(year, month, 1);
      DateTime endDate = DateTime(year, month + 1, 0);

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error filtering transactions by date: $e');
      throw e;
    }
  }


  // Add category to user's Firestore with type
  Future<void> addCategoryToUserFirestore({
    required String userId,
    required String category,
    required String type,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(type)
          .collection('userCategories')
          .doc(category)
          .set({
        'categoryName': category,
      });
    } catch (e) {
      print('Error adding category: $e');
      throw e;
    }
  }

  // Delete category by type
  Future<void> deleteCategory({
    required String userId,
    required String category,
    required String type,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(type)
          .collection('userCategories')
          .doc(category)
          .delete();
    } catch (e) {
      print('Error deleting category: $e');
      throw e;
    }
  }

  // Update category
  Future<void> updateCategory({
    required String userId,
    required String oldCategory,
    required String newCategory,
    required String type,
  }) async {
    try {

      // Update the category name in the categories collection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(type)
          .collection('userCategories')
          .doc(oldCategory)
          .delete();

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(type)
          .collection('userCategories')
          .doc(newCategory)
          .set({
        'categoryName': newCategory,
      });

      // Update the category name in all transactions
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where('category', isEqualTo: oldCategory)
          .get();

      List<Future<void>> updateFutures = [];
      for (var doc in snapshot.docs) {
        updateFutures.add(doc.reference.update({'category': newCategory}));
      }

      await Future.wait(updateFutures);
    } catch (e) {
      print('Error updating category: $e');
      throw e;
    }
  }

  // Delete all categories for a user
  Future<void> deleteAllCategories({required String userId}) async {
    try {
      QuerySnapshot expenseCategoriesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc('Expense')
          .collection('userCategories')
          .get();

      for (var doc in expenseCategoriesSnapshot.docs) {
        await doc.reference.delete();
      }

      QuerySnapshot incomeCategoriesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc('Income')
          .collection('userCategories')
          .get();

      for (var doc in incomeCategoriesSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting all categories: $e');
      throw e;
    }
  }

  // Get user categories by type
  Future<List<CategoryModel>> getUserCategories({
    required String userId,
    required String type,
  }) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(type)
          .collection('userCategories')
          .get();
      return snapshot.docs.map((doc) {
        return CategoryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching user categories: $e');
      throw e;
    }
  }
}
