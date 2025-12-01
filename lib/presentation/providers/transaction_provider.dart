import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:balancea/domain/entities/transaction.dart';
import 'package:balancea/data/repositories/hive_transaction_repository_impl.dart';
import 'package:balancea/domain/repositories/transaction_repository.dart';

part 'transaction_provider.g.dart';

@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  return HiveTransactionRepositoryImpl();
}

@riverpod
class TransactionList extends _$TransactionList {
  @override
  Future<List<Transaction>> build() async {
    final repository = ref.read(transactionRepositoryProvider);
    return await repository.getAllTransactions();
  }

  // Agregar
  Future<void> addTransaction(Transaction transaction) async {
    final repository = ref.read(transactionRepositoryProvider);
    await repository.addTransaction(transaction);
    final previousState = state.value ?? [];
    state = AsyncData([...previousState, transaction]);
  }

  // Editar
  Future<void> updateTransaction(Transaction transaction) async {
    final repository = ref.read(transactionRepositoryProvider);
    await repository.updateTransaction(transaction);

    final previousState = state.value ?? [];
    state = AsyncData([
      for (final t in previousState)
        if (t.id == transaction.id) transaction else t,
    ]);
  }

  // Borrar
  Future<void> deleteTransaction(String id) async {
    final repository = ref.read(transactionRepositoryProvider);
    await repository.deleteTransaction(id);

    final previousState = state.value ?? [];
    state = AsyncData(previousState.where((t) => t.id != id).toList());
  }
}
