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
            return TransactionTile(
              transaction: {
                'title': transaction.title,
                'date':
                    "${transaction.date.day}/${transaction.date.month}", // Formato simple
                'amount': transaction.amount.toString(),
                'type': transaction.isExpense ? 'expense' : 'income',
                'emoji': transaction.categoryEmoji,
              },
            );
          },
        );
      },
    );
  }
}
