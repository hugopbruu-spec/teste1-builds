import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/repositories/room_repository.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/sync_engine.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/status_banner.dart';
import 'room_widgets.dart';

class RoomSyncScreen extends ConsumerWidget {
  const RoomSyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(syncEngineProvider);
    final connectivity = ref.watch(connectivityProvider);
    final roomState = ref.watch(roomRepositoryProvider);
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Sala Sincronizada'),
        actions: [
          IconButton(
            onPressed: () => ref.read(syncEngineProvider.notifier).simulateAdjusting(),
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      bottomNavigationBar: const RoomDock(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status de sync', style: Theme.of(context).textTheme.titleMedium),
              StatusBadge(label: sync.message, color: sync.color),
            ],
          ),
          if (sync.nudgeMs != null || sync.seekDelta != null) ...[
            const SizedBox(height: 8),
            Text(
              sync.nudgeMs != null
                  ? 'Micro-ajuste: ${sync.nudgeMs}ms'
                  : 'Ressincronizando: ${sync.seekDelta?.inSeconds}s',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
          const SizedBox(height: 16),
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Player local'),
                const SizedBox(height: 8),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Icon(Icons.play_circle, size: 64)),
                ),
                const SizedBox(height: 12),
                const Text('Tempo: 12:40 / 28:00'),
                const SizedBox(height: 4),
                const Text('Relógio da sala: 12:40.320'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Ressincronizar agora',
            onPressed: () => ref.read(syncEngineProvider.notifier).resyncNow(),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Simular fora de sync',
            onPressed: () => ref.read(syncEngineProvider.notifier).simulateOutOfSync(),
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}
