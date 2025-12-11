import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:balancea/config/constants/currency_config.dart';
import 'package:balancea/presentation/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  // edicion nombre
  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2D3E),
        title: const Text(
          'Editar Nombre',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Ingresa tu nombre",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4ECDC4)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4ECDC4)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(settingsProvider.notifier)
                    .updateProfile(name: controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Guardar',
              style: TextStyle(color: Color(0xFF4ECDC4)),
            ),
          ),
        ],
      ),
    );
  }

  // cambiar foto
  Future<void> _pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    // Solicitamos imagen de la galería
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Guardamos la RUTA (Path) de la imagen
      ref.read(settingsProvider.notifier).updateProfile(path: image.path);
    }
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F222E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecciona tu Moneda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...CurrencyConfig.availableCurrencies.map((currency) {
                return ListTile(
                  leading: Text(
                    currency.symbol,
                    style: const TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontSize: 24,
                    ),
                  ),
                  title: Text(
                    currency.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    currency.code,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  onTap: () {
                    // Guardar selección
                    ref
                        .read(settingsProvider.notifier)
                        .setCurrency(currency.code);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // borrar datos
  void _confirmDeleteData(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2D3E),
        title: const Text(
          '¿Borrar todo?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Esta acción eliminará todas tus transacciones, configuraciones y PIN. No se puede deshacer.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Cerrar diálogo

              // Ejecutar limpieza
              await ref.read(settingsProvider.notifier).clearAllData();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Datos eliminados correctamente"),
                  ),
                );
              }
            },
            child: const Text(
              'BORRAR',
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

  void _showPremiumDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2D3E),
        icon: const Icon(Icons.star, color: Color(0xFFFFD700), size: 40),
        title: const Text('Sé Premium', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Obtén acceso ilimitado:\n\n'
          '• Sin anuncios\n'
          '• Copia de seguridad\n'
          '• Categorías personalizadas\n',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ECDC4),
            ),
            onPressed: () {
              // SIMULAMOS LA COMPRA
              ref.read(settingsProvider.notifier).setPremium(true);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Bienvenido a Premium! 🌟')),
              );
            },
            child: const Text(
              'Comprar (Simulado)',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final currencyConfig = CurrencyConfig.getCurrency(settings.currencyCode);

    return Scaffold(
      backgroundColor: const Color(0xFF191A22),
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Perfil
          _ProfileCard(
            userName: settings.userName,
            imagePath: settings.avatarPath,
            isPremium: settings.isPremium,
            onEditName: () =>
                _showEditNameDialog(context, ref, settings.userName),
            onEditImage: () => _pickImage(ref),
          ),
          const SizedBox(height: 30),

          // Banner Premium
          if (!settings.isPremium) ...[
            _PremiumBanner(() => _showPremiumDialog(context, ref)),
            const SizedBox(height: 30),
          ],

          // General
          _SectionHeader(title: 'General'),

          _CustomSettingsTile(
            icon: Icons.attach_money,
            color: const Color(0xFF4ECDC4),
            title: 'Moneda Principal',
            subtitle: '${currencyConfig.code} (${currencyConfig.name})',
            onTap: () => _showCurrencyPicker(context, ref),
          ),

          _CustomSettingsTile(
            icon: Icons.category_rounded,
            color: const Color(0xFF6C5CE7),
            title: 'Categorías',
            subtitle: 'Administra tus gastos e ingresos',
            onTap: () {
              // Navegamos a la pantalla de gestión
              context.push('/categories');
            },
          ),

          _CustomSettingsTile(
            icon: Icons.notifications_outlined,
            color: Colors.orangeAccent,
            title: 'Notificaciones',
            subtitle: settings.areNotificationsEnabled
                ? 'Activas'
                : 'Desactivadas',
            onTap: () => settingsNotifier.toggleNotifications(
              !settings.areNotificationsEnabled,
            ),
            showSwitch: true, // Interruptor
            switchValue: settings.areNotificationsEnabled,
            onSwitchChanged: (value) =>
                settingsNotifier.toggleNotifications(value),
          ),

          const SizedBox(height: 25),

          // Segurida
          const _SectionHeader(title: 'Seguridad'),

          _CustomSettingsTile(
            icon: Icons.fingerprint,
            color: const Color(0xFF7C4DFF), // Violeta
            title: 'Biometría',
            subtitle: settings.isBiometricEnabled
                ? 'Activado'
                : 'Usar FaceID / Huella',
            onTap: () =>
                settingsNotifier.toggleBiometric(!settings.isBiometricEnabled),
            showSwitch: true,
            switchValue: settings.isBiometricEnabled,
            onSwitchChanged: (value) => settingsNotifier.toggleBiometric(value),
          ),
          _CustomSettingsTile(
            icon: Icons.lock_outline,
            color: Colors.white,
            title: settings.pin == null ? 'Crear PIN' : 'Cambiar PIN',
            subtitle: settings.pin == null
                ? 'Sin seguridad de respaldo'
                : 'Protegido',
            onTap: () {
              context.push('/pin', extra: true);
            },
          ),
          const SizedBox(height: 25),

          // Data
          const _SectionHeader(title: 'Datos'),

          _CustomSettingsTile(
            icon: Icons.cloud_upload_outlined,
            color: Colors.blueAccent,
            title: 'Copia de Seguridad',
            subtitle: settings.isPremium ? 'Sincronizar ahora' : 'Solo Premium',
            isLocked: !settings.isPremium, // Candado visual
            onTap: () {
              if (!settings.isPremium) {
                _showPremiumDialog(context, ref);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de Backup en desarrollo'),
                  ),
                );
              }
            },
          ),

          _CustomSettingsTile(
            icon: Icons.delete_outline,
            color: const Color(0xFFFF6B6B), // Rojo
            title: 'Borrar Datos',
            onTap: () => _confirmDeleteData(context, ref),
          ),

          const SizedBox(height: 40),

          // Version app
          Center(
            child: Text(
              'Balancea v1.0.0',
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
          ),

          // BOTÓN DE DESARROLLADOR: Resetear Premium (Para que puedas probar)
          // Esto es solo para ti, para volver a ser Free y probar los anuncios de nuevo
          if (settings.isPremium)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextButton(
                onPressed: () => settingsNotifier.setPremium(false),
                child: const Text(
                  "Dev: Volver a modo Gratuito",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CustomSettingsTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final bool showSwitch;
  final bool isLocked;
  final VoidCallback onTap;

  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  const _CustomSettingsTile({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.showSwitch = false,
    this.isLocked = false,
    required this.onTap,
    this.switchValue = false,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.hardEdge,

        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 70),
            alignment: Alignment.center,

            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),

              // Icono Principal
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),

              // Textos
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: subtitle != null
                  ? Text(
                      subtitle!,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    )
                  : null,

              // Elemento final
              trailing: isLocked
                  ? Icon(Icons.lock, color: Colors.grey[600], size: 20)
                  : showSwitch
                  ? Switch(
                      value: switchValue,
                      onChanged: onSwitchChanged,
                      activeTrackColor: const Color(0xFF4ECDC4),
                    )
                  : const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _PremiumBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _PremiumBanner(this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF7C4DFF),
              Color(0xFF4ECDC4),
            ], // Gradiente Violeta -> Turquesa
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.star, color: Colors.white, size: 40),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pásate a Premium',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Sincronización en la nube y sin anuncios.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'VER',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String userName;
  final String? imagePath;
  final VoidCallback onEditName;
  final VoidCallback onEditImage;
  final bool isPremium;

  const _ProfileCard({
    required this.userName,
    this.imagePath,
    required this.onEditName,
    required this.onEditImage,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? bgImage;
    if (imagePath != null) {
      bgImage = FileImage(File(imagePath!));
    }
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onEditImage,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Borde sutil color neon
                    border: Border.all(
                      color: const Color(0xFF4ECDC4),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF191A22),
                    backgroundImage: bgImage,
                    child: imagePath == null
                        ? const Text('📷', style: TextStyle(fontSize: 30))
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF2A2D3E),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hola,',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Tipo usuario
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPremium
                        ? const Color(0xFFFFD700).withValues(
                            alpha: 0.15,
                          ) // Dorado si es premium
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isPremium ? 'Usuario Premium' : 'Usuario Gratuito',
                    style: TextStyle(
                      color: isPremium
                          ? const Color(0xFFFFD700)
                          : const Color(0xFF4ECDC4),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEditName,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
