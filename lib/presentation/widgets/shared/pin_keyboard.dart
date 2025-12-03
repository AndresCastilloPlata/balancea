import 'package:flutter/material.dart';

class PinKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDelete;
  final VoidCallback? onBiometric;

  const PinKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onDelete,
    this.onBiometric,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 20),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 20),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón Biometría (Izquierda)
              Expanded(
                child: onBiometric != null
                    ? IconButton(
                        onPressed: onBiometric,
                        icon: const Icon(
                          Icons.fingerprint,
                          size: 32,
                          color: Color(0xFF4ECDC4),
                        ),
                      )
                    : const SizedBox(), // Espacio vacío si no hay biometría
              ),

              // El Cero
              Expanded(
                child: _NumberButton(
                  number: '0',
                  onPressed: () => onKeyPressed('0'),
                ),
              ),

              // Botón Borrar (Derecha)
              Expanded(
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.backspace_outlined,
                    size: 28,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        return Expanded(
          child: _NumberButton(
            number: number,
            onPressed: () => onKeyPressed(number),
          ),
        );
      }).toList(),
    );
  }
}

class _NumberButton extends StatelessWidget {
  final String number;
  final VoidCallback onPressed;
  const _NumberButton({required this.number, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Estilo Rockero: Borde sutil, fondo oscuro
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
