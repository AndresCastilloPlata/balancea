import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
  String _authorized = 'No autorizado';

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    setState(() {
      _isAuthenticating = true;
    });

    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      // Si no tiene biometricos
      if (!canAuthenticate) {
        if (mounted) context.go('/');
        return;
      }

      // Con biometrico
      authenticated = await auth.authenticate(
        localizedReason: 'Escanea tu rostro para ver tus finanzas',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException catch (e) {
      setState(() {
        _authorized = 'Error: ${e.message}';
        return;
      });
    }

    if (!mounted) return;

    setState(() {
      _isAuthenticating = false;
    });

    if (authenticated) {
      context.go('/');
    } else {
      setState(() {
        _authorized = 'Autenticación fallida';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191A22),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.lock_outline, size: 80, color: Color(0xFF4ECDC4)),
            const SizedBox(height: 20),

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
              _authorized == 'No autorizado'
                  ? 'Verificando identidad...'
                  : _authorized,
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 40),

            // Botón por si falla el automático o el usuario canceló
            if (!_isAuthenticating)
              ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint),
                label: const Text("Intentar de nuevo"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  foregroundColor: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
