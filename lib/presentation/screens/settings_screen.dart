import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          _ProfileCard(),
          const SizedBox(height: 30),

          // Banner Premium
          _PremiumBanner(),
          const SizedBox(height: 30),

          // General
          _SectionHeader(title: 'General'),
          const SizedBox(height: 25),

          _CustomSettingsTile(
            icon: Icons.attach_money,
            color: const Color(0xFF4ECDC4),
            title: 'Moneda Principal',
            subtitle: 'COP (Peso Colombiano)',
            onTap: () {},
          ),
          _CustomSettingsTile(
            icon: Icons.notifications_outlined,
            color: Colors.orangeAccent,
            title: 'Notificaciones',
            subtitle: 'Activas (9:00 AM)',
            onTap: () {},
            showSwitch: true, // Interruptor
          ),

          const SizedBox(height: 25),

          // Segurida
          const _SectionHeader(title: 'Seguridad'),

          _CustomSettingsTile(
            icon: Icons.fingerprint,
            color: const Color(0xFF7C4DFF), // Violeta
            title: 'Biometría',
            subtitle: 'Usar FaceID / Huella',
            onTap: () {},
            showSwitch: true,
          ),
          _CustomSettingsTile(
            icon: Icons.lock_outline,
            color: Colors.white,
            title: 'Cambiar PIN',
            onTap: () {},
          ),
          const SizedBox(height: 25),

          // Data
          const _SectionHeader(title: 'Datos'),

          _CustomSettingsTile(
            icon: Icons.cloud_upload_outlined,
            color: Colors.blueAccent,
            title: 'Copia de Seguridad',
            subtitle: 'Solo Premium',
            onTap: () {},
            isLocked: true, // Candado visual
          ),

          _CustomSettingsTile(
            icon: Icons.delete_outline,
            color: const Color(0xFFFF6B6B), // Rojo
            title: 'Borrar Datos',
            onTap: () {},
          ),

          const SizedBox(height: 40),

          // Version app
          Center(
            child: Text(
              'Balancea v1.0.0',
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
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

  const _CustomSettingsTile({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.showSwitch = false,
    this.isLocked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(15),

        clipBehavior: Clip.hardEdge,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),

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
                  value: true, // Dummy value
                  onChanged: (val) {},
                  activeTrackColor: const Color(0xFF4ECDC4),
                )
              : const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 16,
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
  const _PremiumBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF191A22),
            child: Text('👨‍💻', style: TextStyle(fontSize: 30)),
          ),
          const SizedBox(width: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ingeniero',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Usuario Gratuito',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () {}, // Editar perfil
          ),
        ],
      ),
    );
  }
}
