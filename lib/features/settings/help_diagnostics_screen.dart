import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../room/controllers/room_controller.dart';

class HelpDiagnosticsScreen extends ConsumerWidget {
  const HelpDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);
    final isOffline = connectivityAsync.value?.isOffline ?? false;
    final roomAsync = ref.watch(activeRoomProvider);
    return GradientScaffold(
      appBar: AppBar(title: const Text('Ajuda & Diagnóstico')),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Diagnóstico rápido', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Conexão: ${isOffline ? 'Offline' : 'Online'}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          roomAsync.when(
            data: (roomState) => GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sala ativa', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Código: ${roomState.room.code}'),
                  Text('Modo: ${roomState.room.modeLabel}'),
                  Text('Participantes: ${roomState.participants.length}'),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
