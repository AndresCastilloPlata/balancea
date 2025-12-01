import 'package:balancea/presentation/widgets/shared/add_transaction_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:balancea/presentation/providers/transaction_provider.dart';
import 'package:balancea/presentation/widgets/shared/transaction_tile.dart';

class HomeTransactions extends ConsumerWidget {
  const HomeTransactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionListProvider);

    return transactionState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stackTrace) => Center(child: Text('Error: $err')),
      data: (transactions) {
        if (transactions.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No hay movimientos aún',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          itemCount: transactions.length,
          itemBuilder: (BuildContext context, int index) {
            final transaction = transactions.reversed.toList()[index];

            // Funcionalidad de borrar
            return Dismissible(
              key: Key(transaction.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              onDismissed: (direction) {
                ref
                    .read(transactionListProvider.notifier)
                    .deleteTransaction(transaction.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${transaction.title} eliminado'),
                    backgroundColor: const Color(0xFF1F222E),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },

              // Tile (visualizacion + edicion)
              child: TransactionTile(
                transaction: transaction,
                onTap: () {
                  // Modal en modo edicion
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddTransactionModal(
                      isExpense: transaction.isExpense,
                      transactionToEdit: transaction,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
