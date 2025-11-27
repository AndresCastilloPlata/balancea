import 'package:balancea/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(Transaction transaction);
  Future<List<Transaction>> getAllTransactions();
  Future<void> deleteTransaction(String id);
  Future<void> updateTransaction(Transaction transaction);
}
