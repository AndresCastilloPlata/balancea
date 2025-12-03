import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:balancea/presentation/providers/settings_provider.dart';
import 'package:balancea/presentation/widgets/shared/pin_keyboard.dart';

class PinScreen extends ConsumerStatefulWidget {
  final bool isCreationMode;
  const PinScreen({super.key, required this.isCreationMode});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  String _inputPin = ""; // Lo que el usuario escribe
  String? _firstPin; // Para guardar el primer intento en modo creación
  String _title = ""; // Título dinámico

  Color _dotsColor = const Color(0xFF4ECDC4);

  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _title = widget.isCreationMode ? "Crea tu PIN" : "Ingresa tu PIN";
  }

  // Manejo de pulsación
  void _onKeyPressed(String number) {
    if (_inputPin.length < 4) {
      setState(() {
        _dotsColor = const Color(0xFF4ECDC4); // Reset color
        _inputPin += number;
      });

      // Si completó los 4 dígitos, validamos automáticamente
      if (_inputPin.length == 4) {
        _validatePin();
      }
    }
  }

  void _onDelete() {
    if (_inputPin.isNotEmpty) {
      setState(() {
        _inputPin = _inputPin.substring(0, _inputPin.length - 1);
        _dotsColor = const Color(0xFF4ECDC4);
      });
    }
  }

  void _validatePin() async {
    // Esperamos un momento visual para que el usuario vea que llenó el 4to punto
    await Future.delayed(const Duration(milliseconds: 200));

    if (widget.isCreationMode) {
      _handleCreationLogic();
    } else {
      _handleAuthLogic();
    }
  }

  //  Crear PIN
  void _handleCreationLogic() {
    if (_firstPin == null) {
      // Paso 1: Guardamos el primer intento y pedimos confirmación
      setState(() {
        _firstPin = _inputPin;
        _inputPin = ""; // Limpiamos para el segundo intento
        _title = "Confirma tu PIN";
      });
    } else {
      // Comparar confirmación
      if (_inputPin == _firstPin) {
        // ÉXITO: Guardamos en Hive
        ref.read(settingsProvider.notifier).setPin(_inputPin);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("PIN configurado correctamente")),
          );
          context.pop(); // Volver a ajustes
        }
      } else {
        // ERROR: No coinciden
        _showError("Los PIN no coinciden. Intenta de nuevo.");
        setState(() {
          _firstPin = null; // Reiniciar proceso
          _inputPin = "";
          _title = "Crea tu PIN";
        });
      }
    }
  }

  // Verificar PIN (Login)
  void _handleAuthLogic() {
    final storedPin = ref.read(settingsProvider).pin;

    // Caso raro: No hay PIN guardado pero llegó aquí (Backdoor dev)
    if (storedPin == null) {
      context.go('/home');
      return;
    }

    if (_inputPin == storedPin) {
      // ÉXITO: Entrar a la app
      context.go('/home');
    } else {
      // ERROR: PIN Incorrecto
      _showError("PIN Incorrecto");
      setState(() {
        _inputPin = "";
      });
    }
  }

  // PIN olvidado
  Future<void> _recoverWithBiometrics() async {
    try {
      final bool canCheck =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();

      if (!canCheck) {
        _showError("Tu dispositivo no soporta biometría para recuperar");
        return;
      }

      final bool authenticated = await auth.authenticate(
        localizedReason: 'Usa tu biometría para recuperar el acceso',
        biometricOnly: true,
        // persistAcrossBackgrounding: true,
        sensitiveTransaction: true,
      );

      if (authenticated && mounted) {
        // Si pasa la biometría, asumimos que es el dueño.
        // Lo mandamos al Home. Desde ahí podrá ir a Ajustes y cambiar el PIN si quiere.
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Identidad verificada")));
        context.go('/home');
      }
    } on PlatformException catch (e) {
      debugPrint('Error en recuperación biométrica: $e'); // Manejo silencioso
    }
  }

  void _showError(String msg) {
    // Feedback vibrante o visual
    setState(() {
      _dotsColor = Colors.redAccent;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191A22),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Solo mostramos botón atrás si estamos creando, no si estamos bloqueados
        leading: widget.isCreationMode
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Icono candado
          const Icon(Icons.lock_outline, size: 50, color: Colors.grey),
          const SizedBox(height: 20),

          // Título
          Text(
            _title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),

          // Indicadores de Puntos (****)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final bool isFilled = index < _inputPin.length;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled
                      ? _dotsColor
                      : Colors.white.withValues(alpha: 0.1),
                  border: isFilled ? null : Border.all(color: Colors.grey),
                  boxShadow: isFilled
                      ? [
                          BoxShadow(
                            color: _dotsColor.withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),

          const Spacer(),

          // Olvidé mi PIN (Solo visible en modo Ingreso)
          if (!widget.isCreationMode)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextButton(
                onPressed: _recoverWithBiometrics,
                child: const Text(
                  "¿Olvidaste tu PIN?",
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

          // Teclado Numérico
          PinKeyboard(
            onKeyPressed: _onKeyPressed,
            onDelete: _onDelete,
            // Solo mostramos biometrico en modo ingreso, NO en creación
            onBiometric: !widget.isCreationMode
                ? () =>
                      context.go('/auth') // Volver a intentar biometrico
                : null,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
