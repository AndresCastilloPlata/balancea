import 'package:balancea/domain/entities/transaction.dart';
import 'package:balancea/domain/repositories/transaction_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveTransactionRepositoryImpl implements TransactionRepository {
  // Nombre de la caja
  static const String boxName = 'transactions_box';

  // Funcion auxiliar para abrir la caja si no esta abierta
  Future<Box<Transaction>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Transaction>(boxName);
    } else {
      return await Hive.openBox<Transaction>(boxName);
    }
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final box = await _getBox();
    await box.put(transaction.id, transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final box = await _getBox();
    return box.values.toList();
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final box = await _getBox();
    await box.put(transaction.id, transaction);
  }
}
