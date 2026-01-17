import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/sync_engine.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';

class HelpDiagnosticsScreen extends ConsumerWidget {
  const HelpDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    final sync = ref.watch(syncEngineProvider);
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
                Text('Conexão: ${connectivity.isOffline ? 'Offline' : 'Online'}'),
                Text('Sync: ${sync.message}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Simular offline',
            onPressed: () => ref.read(connectivityProvider.notifier).simulateOffline(),
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Simular reconexão',
            onPressed: () => ref.read(connectivityProvider.notifier).simulateReconnecting(),
            isOutlined: true,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Voltar online',
            onPressed: () => ref.read(connectivityProvider.notifier).simulateOnline(),
            isOutlined: true,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Simular jitter alto',
            onPressed: () => ref.read(syncEngineProvider.notifier).simulateAdjusting(),
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Simular fora de sync',
            onPressed: () => ref.read(syncEngineProvider.notifier).simulateOutOfSync(),
            isOutlined: true,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Ressincronizar',
            onPressed: () => ref.read(syncEngineProvider.notifier).resyncNow(),
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}
