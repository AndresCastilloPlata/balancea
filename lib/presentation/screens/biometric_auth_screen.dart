import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String _message = 'Verificando identidad...';

  // Icono dinámico
  IconData _icon = Icons.fingerprint;
  Color _iconColor = const Color(0xFF4ECDC4);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    setState(() {
      _isAuthenticating = true;
      _message = 'Escanea tu rostro o huella';
      _icon = Icons.fingerprint;
      _iconColor = const Color(0xFF4ECDC4);
    });

    try {
      // Verificar hardware
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      final bool isDeviceSupported = await auth.isDeviceSupported();

      // Si no tiene biometricos
      if (!canCheckBiometrics && !isDeviceSupported) {
        if (mounted) context.go('/home');
        return;
      }

      // Con biometrico
      authenticated = await auth.authenticate(
        localizedReason: 'Balancea requiere tu autorización',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      if (!mounted) return;

      String errorCode = 'unknown';
      if (e is PlatformException) {
        errorCode = e.code;
      }

      if (errorCode == 'userCanceled' || errorCode == 'auth_in_progress') {
        setState(() {
          _message = 'Ingreso cancelado';
          _icon = Icons.cancel_outlined;
          _iconColor = Colors.orange;
        });
      } else if (errorCode == 'NotAvailable') {
        setState(() => _message = 'Biometría no disponible');
      } else if (errorCode == 'LockedOut') {
        setState(() {
          _message = 'Bloqueado temporalmente por intentos fallidos';
          _icon = Icons.timer;
          _iconColor = Colors.red;
        });
      } else {
        setState(() {
          _message = 'Error de autenticación';
          _icon = Icons.error_outline;
          _iconColor = Colors.red;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }

    if (!mounted) return;

    if (authenticated) {
      context.go('/home');
    } else {
      if (_message == 'Escanea tu rostro o huella') {
        setState(() {
          _message = 'No pudimos verificar tu identidad';
          _icon = Icons.lock_person;
          _iconColor = Colors.redAccent;
        });
      }
    }
  }

  void _enterWithPin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Módulo de PIN pendiente de implementación"),
        backgroundColor: Colors.grey,
      ),
    );
    // AQUÍ LUEGO CONECTAREMOS CON LA PANTALLA DE PIN
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191A22),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // Icono animado o estático
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _iconColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: _iconColor.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Icon(_icon, size: 60, color: _iconColor),
            ),
            const SizedBox(height: 40),

            const Text(
              'Balancea Protegido',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),
            Text(
              _message,
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            // Botón por si falla el automático o el usuario canceló
            if (!_isAuthenticating) ...[
              // 1. Botón Principal: Reintentar Biometría
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _authenticate,
                  icon: const Icon(Icons.face),
                  label: const Text("Usar FaceID / Huella"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ECDC4),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. Botón Secundario: Usar PIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _enterWithPin,
                  icon: const Icon(Icons.dialpad),
                  label: const Text("Ingresar con PIN"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Si está autenticando, mostramos loader
              const CircularProgressIndicator(color: Color(0xFF4ECDC4)),
            ],
          ],
        ),
      ),
    );
  }
}
