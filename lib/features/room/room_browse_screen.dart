import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/repositories/room_repository.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/status_banner.dart';
import 'room_widgets.dart';

class RoomBrowseScreen extends ConsumerWidget {
  const RoomBrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    final roomState = ref.watch(roomRepositoryProvider);
    return GradientScaffold(
      appBar: AppBar(title: const Text('Navegação Conjunta')),
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
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Navegador do host'),
                const SizedBox(height: 8),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Icon(Icons.public, size: 64)),
                ),
                const SizedBox(height: 12),
                const Text('URL sincronizada: https://example.com'),
                const SizedBox(height: 4),
                const Text('Scroll e cliques do host sincronizados.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Abrir navegador interno',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Sincronizar scroll agora',
            onPressed: () {},
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}
