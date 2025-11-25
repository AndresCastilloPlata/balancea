import 'package:flutter/material.dart';

class HomeTransactions extends StatelessWidget {
  const HomeTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      itemCount: _dummyTransactions.length,
      itemBuilder: (BuildContext context, int index) {
        final transaction = _dummyTransactions[index];
        return _TransactionItem(transaction: transaction);
      },
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction['type'] == 'expense';
    final color = isExpense ? const Color(0xFFFF6B6B) : const Color(0xFF4ECDC4);
    final icon = isExpense ? Icons.shopping_bag_outlined : Icons.attach_money;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

        // Izquierda: Icono circular
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),

        // Centro: Titulo + fecha
        title: Text(
          transaction['title'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          transaction['date'],
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),

        //Derecha: Monto
        trailing: Text(
          '${isExpense ? "-" : "+"} \$${transaction['amount']}',
          style: TextStyle(
            color: color, // El color del texto coincide con el tipo
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
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
