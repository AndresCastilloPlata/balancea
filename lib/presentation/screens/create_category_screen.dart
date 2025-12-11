import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:balancea/presentation/providers/category_provider.dart';

class CreateCategoryScreen extends ConsumerStatefulWidget {
  final bool isExpense;

  const CreateCategoryScreen({super.key, required this.isExpense});

  @override
  ConsumerState<CreateCategoryScreen> createState() =>
      _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends ConsumerState<CreateCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController();

  // Gasto => Rojo | Ingreso => Verde (defecto)
  late Color _selectedColor;
  String _selectedEmoji = "🏷️";

  // Paleta de colores Premium (Neón/Oscuros)
  final List<Color> _colors = const [
    Color(0xFFFF6B6B), // Rojo Balancea
    Color(0xFF4ECDC4), // Verde Balancea
    Color(0xFFFFD93D), // Amarillo
    Color(0xFF6C5CE7), // Morado
    Color(0xFFA55EEA), // Violeta
    Color(0xFFFF7675), // Salmón
    Color(0xFF74B9FF), // Azul Claro
    Color(0xFF0984E3), // Azul Fuerte
    Color(0xFF00B894), // Esmeralda
    Color(0xFFE17055), // Naranja quemado
    Color(0xFFFD79A8), // Rosa
    Color(0xFF636E72), // Gris
  ];

  // Emojis sugeridos para finanzas
  final List<String> _suggestedEmojis = [
    "🍔",
    "🚗",
    "🏠",
    "💊",
    "🎮",
    "✈️",
    "🛒",
    "🎓",
    "🎁",
    "💪",
    "🐶",
    "👶",
    "💻",
    "📚",
    "🔧",
    "🏦",
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.isExpense
        ? const Color(0xFFFF6B6B)
        : const Color(0xFF4ECDC4);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  bool _isEmoji(String text) {
    final regex = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );
    return regex.hasMatch(text);
  }

  void _saveCategory() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Escribe un nombre para la categoría")),
      );
      return;
    }

    // Provider para guardar en Hive
    ref
        .read(categoryListProvider.notifier)
        .addCategory(
          name: name,
          emoji: _selectedEmoji,
          colorValue: _selectedColor.toHexInt(),
          isExpense: widget.isExpense,
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    // Detecta si el teclado está abierto para ajustar padding

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1F222E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.isExpense
                ? "Nueva Categoría de Gasto"
                : "Nueva Categoría de Ingreso",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Previw de la categoria
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2D3E),
                          shape: BoxShape.circle,
                          border: Border.all(color: _selectedColor, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: _selectedColor.withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _selectedEmoji,
                            style: const TextStyle(fontSize: 45),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      Text(
                        _nameController.text.isEmpty
                            ? "Nombre Categoría"
                            : _nameController.text,
                        style: TextStyle(
                          color: _selectedColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Input nombre
                const Text(
                  "Nombre",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _nameController,
                  onChanged: (val) => setState(() {}),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Ej: Netflix, Gimnasio...",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF2A2D3E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.edit, color: _selectedColor),
                  ),
                ),

                const SizedBox(height: 30),

                // Selector Color
                const Text(
                  "Color",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    itemCount: _colors.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final color = _colors[index];
                      final isSelected = color == _selectedColor;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 15),
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.6),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Selector de emoji
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Icono",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    // Opción para emoji manual
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: TextField(
                        controller: _emojiController,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          counterText: "", // Ocultar contador 0/1
                          hintText: "⌨️ Seleccionar",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                          contentPadding: const EdgeInsets.only(bottom: 10),
                          filled: true,
                          fillColor: const Color(0xFF2A2D3E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          if (val.isEmpty) return;

                          // VALIDACIÓN ESTRICTA: ¿Es Emoji?
                          if (_isEmoji(val)) {
                            setState(() => _selectedEmoji = val);
                            // Ocultar teclado tras éxito
                            FocusScope.of(context).unfocus();
                          } else {
                            // Si no es emoji, limpiamos y avisamos
                            _emojiController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Por favor, usa solo emojis 🙃"),
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Grilla de sugerencias
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _suggestedEmojis.length,
                  itemBuilder: (context, index) {
                    final emoji = _suggestedEmojis[index];
                    final isSelected = emoji == _selectedEmoji;

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedEmoji = emoji);
                        _emojiController.clear(); // Limpiar el input manual
                        FocusScope.of(context).unfocus(); // Cerrar teclado
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedColor.withValues(alpha: 0.2)
                              : const Color(0xFF2A2D3E),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: _selectedColor)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Boton Guardar
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _saveCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      shadowColor: _selectedColor.withValues(alpha: 0.5),
                    ),
                    child: const Text(
                      "Crear Categoría",
                      style: TextStyle(
                        color: Colors.black, // Contraste fuerte
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension ColorExtension on Color {
  /// Devuelve el valor entero ARGB compatible con versiones nuevas y viejas de Flutter
  int toHexInt() {
    // Convertimos manualmente los componentes a un entero de 32 bits
    // (Alpha << 24) | (Red << 16) | (Green << 8) | Blue
    final a = (this.a * 255).round();
    final r = (this.r * 255).round();
    final g = (this.g * 255).round();
    final b = (this.b * 255).round();

    return (a << 24) | (r << 16) | (g << 8) | b;
  }
}
