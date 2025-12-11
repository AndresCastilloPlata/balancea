import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:balancea/domain/entities/category.dart';
import 'package:balancea/presentation/providers/category_provider.dart';
import 'package:balancea/presentation/providers/settings_provider.dart';

class CategoriesManagerScreen extends ConsumerWidget {
  const CategoriesManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);
    final settings = ref.watch(settingsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF1F222E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Mis Categorías",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => context.pop(),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFF4ECDC4),
            labelColor: Color(0xFF4ECDC4),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Gastos"),
              Tab(text: "Ingresos"),
            ],
          ),
        ),
        body: categoriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("Error: $err")),
          data: (categories) {
            // Filtramos las listas
            final expenses = categories.where((c) => c.isExpense).toList();
            final incomes = categories.where((c) => !c.isExpense).toList();

            return TabBarView(
              children: [
                _CategoryListView(
                  categories: expenses,
                  isPremium: settings.isPremium,
                ),
                _CategoryListView(
                  categories: incomes,
                  isPremium: settings.isPremium,
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (settings.isPremium) {
              // Por defecto abrimos crear Gasto, el usuario puede cambiarlo en la pantalla
              context.push('/create-category', extra: true);
            } else {
              _showPremiumDialog(context);
            }
          },
          backgroundColor: const Color(0xFF4ECDC4),
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2D3E),
        title: const Text(
          "Función Premium",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Necesitas Premium para crear categorías ilimitadas.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}

class _CategoryListView extends ConsumerWidget {
  final List<Category> categories;
  final bool isPremium;

  const _CategoryListView({required this.categories, required this.isPremium});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 50, color: Colors.grey[700]),
            const SizedBox(height: 10),
            Text(
              "No hay categorías",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2D3E),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(category.colorValue).withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Color(category.colorValue), width: 1),
              ),
              child: Center(
                child: Text(
                  category.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            title: Text(
              category.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Solo las categorías CUSTOM (creadas por usuario) se pueden borrar
                if (category.isCustom)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFFF6B6B),
                    ),
                    onPressed: () => _confirmDelete(context, ref, category),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ),
              ],
            ),
            onTap: () {
              // Aquí conectaremos la edición en el siguiente paso
              if (!category.isCustom) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Las categorías del sistema no se pueden editar",
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Próximamente: Editar (Requiere ajustar CreateCategoryScreen)",
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Category category) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F222E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "¿Eliminar categoría?",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Se eliminará '${category.name}'.\nLas transacciones que usen esta categoría no se borrarán, pero perderán su icono.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              ref.read(categoryListProvider.notifier).deleteCategory(category);
              Navigator.pop(ctx);
            },
            child: const Text(
              "Eliminar",
              style: TextStyle(
                color: Color(0xFFFF6B6B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
