import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/widgets/gradient_scaffold.dart';

class NetworkPerformanceScreen extends ConsumerWidget {
  const NetworkPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    return GradientScaffold(
      appBar: AppBar(title: const Text('Rede & Desempenho')),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            title: const Text('Qualidade preferida'),
            subtitle: const Text('Alta'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          SwitchListTile(
            title: const Text('Correção automática de atraso'),
            value: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          Text('Status de conexão', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            connectivity.isOffline
                ? 'Offline'
                : connectivity.isReconnecting
                    ? 'Reconectando…'
                    : 'Online',
          ),
        ],
      ),
    );
  }
}
