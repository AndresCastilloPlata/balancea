import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final bool isExpense;
  @HiveField(5)
  final String categoryEmoji;
  @HiveField(6)
  final String? note;
  @HiveField(7)
  final String? imagePath;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.categoryEmoji,
    this.note,
    this.imagePath,
  });
}
