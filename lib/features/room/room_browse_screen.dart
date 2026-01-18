import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/status_banner.dart';
import 'controllers/room_controller.dart';
import 'room_widgets.dart';

class RoomBrowseScreen extends ConsumerWidget {
  const RoomBrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);
    final isOffline = connectivityAsync.value?.isOffline ?? false;
    final roomAsync = ref.watch(activeRoomProvider);
    return GradientScaffold(
      appBar: AppBar(title: const Text('Navegação Conjunta')),
      bottomNavigationBar: const RoomDock(),
      child: roomAsync.when(
        data: (roomState) => ListView(
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
            GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Navegador do host'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 220,
                    child: roomState.room.contentUrl.isEmpty
                        ? const Center(child: Text('Defina um link para começar.'))
                        : WebViewWidget(
                            controller: WebViewController()
                              ..setJavaScriptMode(JavaScriptMode.unrestricted)
                              ..loadRequest(Uri.parse(roomState.room.contentUrl)),
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text('URL sincronizada: ${roomState.room.contentUrl}'),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
