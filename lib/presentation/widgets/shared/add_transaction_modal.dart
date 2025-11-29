import 'package:balancea/domain/entities/transaction.dart';
import 'package:balancea/presentation/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddTransactionModal extends ConsumerStatefulWidget {
  final bool isExpense;
  const AddTransactionModal({super.key, required this.isExpense});

  @override
  ConsumerState<AddTransactionModal> createState() =>
      _AddTransactionModalState();
}

class _AddTransactionModalState extends ConsumerState<AddTransactionModal> {
  // Controladores
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  // Categoria
  late String selectedEmoji;

  final List<Map<String, String>> expenseCategories = [
    {'icon': '🍔', 'name': 'Comida'},
    {'icon': '🚌', 'name': 'Transporte'},
    {'icon': '💡', 'name': 'Servicios'},
  ];

  final List<Map<String, String>> incomeCategories = [
    {'icon': '💰', 'name': 'Sueldo'},
    {'icon': '🏠', 'name': 'Renta'},
    {'icon': '🎁', 'name': 'Regalo'},
  ];

  @override
  void initState() {
    super.initState();
    selectedEmoji = widget.isExpense
        ? expenseCategories.first['icon']!
        : incomeCategories.first['icon']!;
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    // Valida que no este vacio
    if (titleController.text.isEmpty || amountController.text.isEmpty) return;

    final double? amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;

    // Crea el objeto
    final newTransaction = Transaction(
      id: const Uuid().v4(),
      title: titleController.text,
      amount: amount,
      date: DateTime.now(),
      isExpense: widget.isExpense,
      categoryEmoji: selectedEmoji,
      note: noteController.text,
    );

    // Llama al proider para guardar
    ref.read(transactionListProvider.notifier).addTransaction(newTransaction);

    // Cerrar modal
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isExpense
        ? const Color(0xFFFF6B6B)
        : const Color(0xFF4ECDC4);

    final currentCategories = widget.isExpense
        ? expenseCategories
        : incomeCategories;
    // Padding para que el teclado no tape el formulario
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + keyboardPadding),
      decoration: const BoxDecoration(
        color: Color(0xFF1F222E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barrita decorativa superior
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Titulo del modal
          Text(
            widget.isExpense ? 'Registrar Gasto' : 'Registrar Ingreso',
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Categoría',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentCategories.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == currentCategories.length) {
                  return GestureDetector(
                    onTap: () {
                      // TODO: Implementar lógica de límites Free vs Premium
                      print(
                        "Agregar nueva categoría (Lógica Premium pendiente)",
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 60,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2D3E),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Crear",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // item normales
                final category = currentCategories[index];
                final emoji = category['icon']!;
                final name = category['name']!;
                final isSelected = emoji == selectedEmoji;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedEmoji = emoji;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 65,

                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(alpha: 0.2)
                                : const Color(0xFF2A2D3E),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: color, width: 2)
                                : null,
                          ),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Nombre categoria
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10, // Letra pequeña
                            color: isSelected ? color : Colors.grey[400],
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Input 1: Titulo
          _CustomTextField(
            controller: titleController,
            label: widget.isExpense
                ? 'Título (Ej: Almuerzo)'
                : 'Título (Ej: Nómina)',
            icon: Icons.title,
            color: color,
          ),
          const SizedBox(height: 15),

          // Input 2: Monto
          _CustomTextField(
            controller: amountController,
            label: 'Monto (Ej: 20000)',
            icon: Icons.attach_money,
            color: color,
            isNumber: true, // Teclado numérico
          ),
          const SizedBox(height: 15),

          // Input 3: Nota(opcional)
          _CustomTextField(
            controller: noteController,
            label: 'Nota (Opcional)',
            icon: Icons.note_alt_outlined,
            color: color,
          ),
          const SizedBox(height: 30),

          // Boton Guardar
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color color;
  final bool isNumber;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.color,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: Icon(icon, color: color),
        filled: true,
        fillColor: const Color(0xFF2A2D3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color, width: 1),
        ),
      ),
    );
  }
}
