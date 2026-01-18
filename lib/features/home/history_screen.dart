import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/history_service.dart';
import '../../core/widgets/gradient_scaffold.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authServiceProvider).currentUser;
    if (user == null) {
      return const GradientScaffold(child: Center(child: Text('Faça login.')));
    }
    return GradientScaffold(
      appBar: AppBar(title: const Text('Histórico')),
      child: StreamBuilder(
        stream: ref.read(historyServiceProvider).watchHistory(user.uid),
        builder: (context, snapshot) {
          final historyItems = snapshot.data ?? [];
          if (historyItems.isEmpty) {
            return const Center(child: Text('Sem histórico.'));
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: historyItems
                .map(
                  (item) => ListTile(
                    title: Text(item.title),
                    subtitle: Text('${item.subtitle} • ${item.timestampLabel}'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
