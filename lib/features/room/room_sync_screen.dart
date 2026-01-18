import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/status_banner.dart';
import 'controllers/room_controller.dart';
import 'room_widgets.dart';

class RoomSyncScreen extends ConsumerWidget {
  const RoomSyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);
    final isOffline = connectivityAsync.value?.isOffline ?? false;
    final roomAsync = ref.watch(activeRoomProvider);
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Sala Sincronizada'),
      ),
      bottomNavigationBar: const RoomDock(),
      child: roomAsync.when(
        data: (roomState) {
          final sync = roomState.syncState;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (isOffline)
                const StatusBanner(
                  message: 'Sem conexão. Tentando reconectar…',
                  color: Colors.redAccent,
                  icon: Icons.wifi_off,
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
                  StatusBadge(
                    label: sync.isPlaying ? 'Reproduzindo' : 'Pausado',
                    color: sync.isPlaying ? Colors.greenAccent : Colors.orangeAccent,
                  ),
                ],
              ),
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
                    Text('Posição: ${(sync.positionMs / 1000).toStringAsFixed(1)}s'),
                    Text('Atualizado: ${sync.updatedAt.toLocal()}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: sync.isPlaying ? 'Pausar' : 'Reproduzir',
                onPressed: () => ref.read(roomActionsProvider).updateSync(
                      roomId: roomState.roomId,
                      isPlaying: !sync.isPlaying,
                      positionMs: sync.positionMs,
                    ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Ressincronizar agora',
                onPressed: () => ref.read(roomActionsProvider).updateSync(
                      roomId: roomState.roomId,
                      isPlaying: sync.isPlaying,
                      positionMs: sync.positionMs,
                    ),
                isOutlined: true,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
