import 'package:flutter/material.dart';

import '../widgets/shared/transaction_tile.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191A22),
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
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2A2D3E),
                      hintText: 'Buscar transacción...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 15,
                itemBuilder: (context, index) {
                  //Datos falsos
                  return TransactionTile(
                    transaction: {
                      'title': 'Movimiento de prueba #$index',
                      'date': 'Hace $index días',
                      'amount': '${(index + 1) * 10000}',
                      'type': index % 2 == 0
                          ? 'expense'
                          : 'income', // Alternar color
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
