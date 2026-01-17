import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/repositories/room_repository.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/status_banner.dart';

class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    final roomState = ref.watch(roomRepositoryProvider);
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
            const StatusBanner(
              message: 'Sem conexão. Tentando reconectar…',
              color: Colors.redAccent,
              icon: Icons.wifi_off,
            )
          else if (connectivity.isReconnecting)
            const StatusBanner(
              message: 'Reconectando…',
              color: Colors.orangeAccent,
              icon: Icons.sync,
            ),
          if (roomState.room.hostDisconnected)
            const StatusBanner(
              message: 'Host desconectado… aguardando reconexão.',
              color: Colors.orangeAccent,
              icon: Icons.person_off,
            ),
          GlassContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Código da sala', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(
                      roomState.room.code,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                StatusBadge(label: roomState.isHost ? 'Host' : 'Convidado'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Participantes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...roomState.participants.map(
            (participant) => ListTile(
              title: Text(participant.name),
              subtitle: Text(participant.statusLabel),
              trailing: StatusBadge(
                label: participant.roleLabel,
                color: participant.role == ParticipantRole.host
                    ? Colors.greenAccent
                    : Colors.white70,
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
