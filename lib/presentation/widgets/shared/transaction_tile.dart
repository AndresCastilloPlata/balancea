import 'package:balancea/config/helpers/currency_helper.dart';
import 'package:balancea/domain/entities/transaction.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionTile({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = transaction.isExpense
        ? const Color(0xFFFF6B6B)
        : const Color(0xFF4ECDC4);
    // final icon = isExpense ? Icons.shopping_bag_outlined : Icons.attach_money;

    final String emoji = transaction.categoryEmoji;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D3E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          title: Text(
            transaction.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          trailing: Text(
            '${transaction.isExpense ? "-" : "+"} ${CurrencyHelper.format(transaction.amount)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
