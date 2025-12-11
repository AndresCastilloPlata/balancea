import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String emoji;
  @HiveField(3)
  final int colorValue;
  @HiveField(4)
  final bool isExpense;
  @HiveField(5)
  final bool isCustom;

  Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorValue,
    required this.isExpense,
    this.isCustom = false,
  });
}
