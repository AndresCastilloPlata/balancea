import 'package:hive_flutter/adapters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:balancea/config/constants/categories_config.dart';
import 'package:balancea/domain/entities/category.dart';

part 'category_provider.g.dart';

@riverpod
class CategoryList extends _$CategoryList {
  Box<Category>? _box;

  @override
  Future<List<Category>> build() async {
    _box = await Hive.openBox('categories_box');

    if (_box!.isEmpty) {
      await _seedDefaultCategories();
    }

    return _box!.values.toList();
  }

  // LLena la DB inicial
  Future<void> _seedDefaultCategories() async {
    final List<Category> defaults = [];

    // Cargar Gastos (por defecto)
    for (var emoji in CategoriesConfig.defaultExpenses) {
      defaults.add(
        Category(
          id: const Uuid().v4(),
          name: CategoriesConfig.getName(emoji),
          emoji: emoji,
          colorValue: 0xFFFF6B6B,
          isExpense: true,
          isCustom: false,
        ),
      );
    }

    // Cargar Ingresos (por defecto)
    for (var emoji in CategoriesConfig.defaultIncomes) {
      defaults.add(
        Category(
          id: const Uuid().v4(),
          name: CategoriesConfig.getName(emoji),
          emoji: emoji,
          colorValue: 0xFF4ECDC4,
          isExpense: false,
          isCustom: false,
        ),
      );
    }

    // Guarda todo una vez en Hive
    await _box!.addAll(defaults);
  }

  // Crear Categorias
  Future<void> addCategory({
    required String name,
    required String emoji,
    required int colorValue,
    required bool isExpense,
  }) async {
    final newCategory = Category(
      id: const Uuid().v4(),
      name: name,
      emoji: emoji,
      colorValue: colorValue,
      isExpense: isExpense,
      isCustom: true, // creado por el usuario
    );

    await _box!.add(newCategory);

    // actualiza el estado local para la UI
    state = AsyncData(_box!.values.toList());
  }

  // Editar categoria
  Future<void> editCategory(
    Category category, {
    required String name,
    required String emoji,
    required int colorValue,
  }) async {
    category.name = name;
    category.emoji = emoji;
    category.colorValue = colorValue;

    await category.save();

    state = AsyncData(_box!.values.toList());
  }

  Future<void> deleteCategory(Category category) async {
    // No borra categorias base
    if (!category.isCustom) return;

    await category.delete();

    state = AsyncData(_box!.values.toList());
  }
}
