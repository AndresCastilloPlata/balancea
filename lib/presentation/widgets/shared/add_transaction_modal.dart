import 'package:balancea/config/helpers/currency_input_formatter.dart';
import 'package:balancea/domain/entities/transaction.dart';
import 'package:balancea/presentation/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddTransactionModal extends ConsumerStatefulWidget {
  final bool isExpense;
  final Transaction? transactionToEdit;
  const AddTransactionModal({
    super.key,
    required this.isExpense,
    this.transactionToEdit,
  });

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

  bool _isLoading = false;

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

    if (widget.transactionToEdit != null) {
      final transaction = widget.transactionToEdit!;
      titleController.text = transaction.title;
      amountController.text = transaction.amount.toStringAsFixed(
        transaction.amount.truncateToDouble() == transaction.amount ? 0 : 2,
      );
      noteController.text = transaction.note ?? '';
      selectedEmoji = transaction.categoryEmoji;
    } else {
      selectedEmoji = widget.isExpense
          ? expenseCategories.first['icon']!
          : incomeCategories.first['icon']!;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    // Valida que no este vacio
    if (titleController.text.isEmpty || amountController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });
    try {
      // Limpiar monto
      String cleanAmount = amountController.text.replaceAll('.', '');
      cleanAmount = cleanAmount.replaceAll(',', '.');

      final double? amount = double.tryParse(cleanAmount);
      if (amount == null || amount <= 0) {
        throw Exception("Monto inválido");
      }

      // Crea el objeto -> Nuevo
      final transaction = Transaction(
        id: widget.transactionToEdit?.id ?? const Uuid().v4(),
        title: titleController.text,
        amount: amount,
        date: widget.transactionToEdit?.date ?? DateTime.now(),
        isExpense: widget.isExpense,
        categoryEmoji: selectedEmoji,
        note: noteController.text,
      );

      if (widget.transactionToEdit == null) {
        await ref
            .read(transactionListProvider.notifier)
            .addTransaction(transaction);
      } else {
        await ref
            .read(transactionListProvider.notifier)
            .updateTransaction(transaction);
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isExpense
        ? const Color(0xFFFF6B6B)
        : const Color(0xFF4ECDC4);

    final currentCategories = widget.isExpense
        ? expenseCategories
        : incomeCategories;

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final String modalTitle = widget.transactionToEdit == null
        ? (widget.isExpense ? 'Registrar Gasto' : 'Registrar Ingreso')
        : 'Editar Transacción';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1F222E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),

        // padding: EdgeInsets.only(bottom: viewInsets * 0.65),
        child: SingleChildScrollView(
          reverse: true,
          physics: const ClampingScrollPhysics(),

          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              20 + (keyboardHeight * 0.64),
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
                  modalTitle,
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
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // item normales
                      final category = currentCategories[index];
                      final isSelected = category['icon'] == selectedEmoji;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEmoji = category['icon']!;
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
                                  category['icon']!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              const SizedBox(height: 5),

                              // Nombre categoria
                              Text(
                                category['name']!,
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
                const SizedBox(height: 10),

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
                  label: 'Monto (Ej: 20.000)',
                  icon: Icons.attach_money,
                  color: color,
                  isNumber: true,
                  inputFormatters: [
                    CurrencyInputFormatter(),
                  ], // Teclado numérico
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
                    onPressed: _isLoading ? null : _saveTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            widget.transactionToEdit == null
                                ? 'Guardar'
                                : 'Actualizar',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
  final List<TextInputFormatter>? inputFormatters;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.color,
    this.isNumber = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: inputFormatters,
      keyboardType: isNumber
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
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
