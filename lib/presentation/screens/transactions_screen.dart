import 'package:balancea/presentation/providers/transaction_provider.dart';
import 'package:balancea/presentation/widgets/shared/add_transaction_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/shared/transaction_tile.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionListProvider);

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF191A22),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Header + buscador
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Movimientos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Input Busqueda
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2A2D3E),
                      hintText: 'Buscar transacción...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  searchQuery = '';
                                });
                                FocusScope.of(context).unfocus();
                              },
                              icon: Icon(Icons.close, color: Colors.grey),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Lista movimientos
            Expanded(
              child: transactionState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (transactions) {
                  final filteredList = transactions.where((t) {
                    return t.title.toLowerCase().contains(searchQuery);
                  }).toList();
                  final sortedList = filteredList.reversed.toList();

                  if (sortedList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay movimientos',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  return ListView.builder(
                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: 20 + bottomPadding,
                    ),
                    itemCount: sortedList.length,
                    itemBuilder: (context, index) {
                      final transaction = sortedList[index];

                      return Dismissible(
                        key: Key(transaction.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFF6B6B,
                            ).withValues(alpha: 0.8),
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
                        child: TransactionTile(
                          transaction: transaction,

                          onTap: () {
                            // Abrir Modal para Editar
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
