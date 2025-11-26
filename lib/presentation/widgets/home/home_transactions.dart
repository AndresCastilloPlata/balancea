import 'package:flutter/material.dart';
import 'package:balancea/presentation/widgets/shared/transaction_tile.dart';

class HomeTransactions extends StatelessWidget {
  const HomeTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      itemCount: _dummyTransactions.length,
      itemBuilder: (BuildContext context, int index) {
        final transaction = _dummyTransactions[index];
        return TransactionTile(transaction: transaction);
      },
    );
  }
}

// --- DATOS FALSOS (DUMMY DATA) ---
// Esto simula lo que vendría de una base de datos Hive o Firebase
final List<Map<String, dynamic>> _dummyTransactions = [
  {
    'title': 'Comida Rápida',
    'date': 'Hoy, 12:30 PM',
    'amount': '25.000',
    'type': 'expense',
  },
  {
    'title': 'Pago de Nómina',
    'date': 'Ayer, 5:00 PM',
    'amount': '1.200.000',
    'type': 'income',
  },
  {
    'title': 'Uber a Casa',
    'date': 'Ayer, 9:15 PM',
    'amount': '18.500',
    'type': 'expense',
  },
  {
    'title': 'Suscripción Netflix',
    'date': '23 Nov, 2025',
    'amount': '35.000',
    'type': 'expense',
  },
];
