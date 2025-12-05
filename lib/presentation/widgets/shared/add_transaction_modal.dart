import 'package:balancea/config/constants/currency_config.dart';
import 'package:balancea/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:balancea/config/constants/categories_config.dart';
import 'package:balancea/config/helpers/currency_input_formatter.dart';
import 'package:balancea/domain/entities/transaction.dart';
import 'package:balancea/presentation/providers/transaction_provider.dart';

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
  DateTime _selectedDate = DateTime.now();

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
      _selectedDate = transaction.date;
    } else {
      selectedEmoji = widget.isExpense
          ? CategoriesConfig.defaultExpenses.first
          : CategoriesConfig.defaultIncomes.first;
      _selectedDate = DateTime.now();
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
      // Leemos la moneda actual para saber cuál es el separador decimal
      final settings = ref.read(settingsProvider);
      final currency = CurrencyConfig.getCurrency(settings.currencyCode);
      final decimalSep = currency.locale == 'en_US' ? '.' : ',';
      final thousandSep = currency.locale == 'en_US' ? ',' : '.';

      String cleanAmount = amountController.text;

      // Eliminamos separadores de miles
      cleanAmount = cleanAmount.replaceAll(thousandSep, '');
      // Reemplazamos separador decimal por punto (formato Dart standard)
      cleanAmount = cleanAmount.replaceAll(decimalSep, '.');

      final double? amount = double.tryParse(cleanAmount);
      if (amount == null || amount <= 0) {
        throw Exception("Monto inválido");
      }

      // Crea el objeto -> Nuevo
      final transaction = Transaction(
        id: widget.transactionToEdit?.id ?? const Uuid().v4(),
        title: titleController.text,
        amount: amount,
        date: _selectedDate,
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
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final Color dialogBackgroundColor = const Color(0xFF1F222E);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF4ECDC4), // Color de selección
              onPrimary: Colors.black,
              surface: Color(0xFF1F222E), // Fondo del calendario
              onSurface: Colors.white,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: dialogBackgroundColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final currency = CurrencyConfig.getCurrency(settings.currencyCode);

    final color = widget.isExpense
        ? const Color(0xFFFF6B6B)
        : const Color(0xFF4ECDC4);

    final currentCategories = widget.isExpense
        ? CategoriesConfig.defaultExpenses
        : CategoriesConfig.defaultIncomes;

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

                // Categorias
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
                            if (!settings.isPremium) {
                              // Mostrar alerta de bloqueo
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0xFF2A2D3E),
                                  icon: const Icon(
                                    Icons.star,
                                    color: Color(0xFFFFD700),
                                    size: 40,
                                  ),
                                  title: const Text(
                                    "Función Premium",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    "Crear categorías personalizadas es exclusivo para usuarios Premium.",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        "Entendido",
                                        style: TextStyle(
                                          color: Color(0xFF4ECDC4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // Lógica de crear categoría (Futuro)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Crear categoría: Próximamente",
                                  ),
                                ),
                              );
                            }
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
                      final emoji = currentCategories[index];
                      final name = CategoriesConfig.getName(emoji);
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
                    CurrencyInputFormatter(currency: currency),
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

                // Fecha
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2D3E),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: color, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          // Formato legible: "30 de Noviembre de 2025" o similar
                          "Fecha: ${DateFormat.yMMMd('es_CO').format(_selectedDate)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
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
