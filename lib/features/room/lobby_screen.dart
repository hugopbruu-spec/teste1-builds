import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/utils/fake_data.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/status_badge.dart';

class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
        actions: [
          IconButton(
            onPressed: () => context.go('/settings/help'),
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (connectivity.isOffline)
            const _Banner(
              message: 'Sem conexão. Tentando reconectar…',
              color: Colors.redAccent,
            )
          else if (connectivity.isReconnecting)
            const _Banner(
              message: 'Reconectando…',
              color: Colors.orangeAccent,
            ),
          GlassContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Código da sala', style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 4),
                    Text('A7K9Q', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                StatusBadge(label: 'Host'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Participantes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...fakeParticipants.map(
            (participant) => ListTile(
              title: Text(participant['name']!),
              subtitle: Text(participant['status']!),
              trailing: StatusBadge(
                label: participant['role']!,
                color: participant['role'] == 'Host' ? Colors.greenAccent : Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Definir link do conteúdo',
            onPressed: () => context.go('/define-link'),
            icon: Icons.link,
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Abrir sala sincronizada',
            onPressed: () => context.go('/room-sync'),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
