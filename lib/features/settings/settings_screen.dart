import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/gradient_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Configurações')),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            leading: const Icon(Icons.volume_up_outlined),
            title: const Text('Áudio & Vídeo'),
            onTap: () => context.go('/settings/audio-video'),
          ),
          ListTile(
            leading: const Icon(Icons.wifi_tethering_outlined),
            title: const Text('Rede & Desempenho'),
            onTap: () => context.go('/settings/network'),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Ajuda & Diagnóstico'),
            onTap: () => context.go('/settings/help'),
          ),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: const Text('Legal'),
            onTap: () => context.go('/settings/legal'),
          ),
        ],
      ),
    );
  }
}
