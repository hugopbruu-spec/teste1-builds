import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/repositories/history_repository.dart';
import '../../core/widgets/gradient_scaffold.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyItems = ref.watch(historyRepositoryProvider).fetchHistory();
    return GradientScaffold(
      appBar: AppBar(title: const Text('Histórico')),
      child: ListView(
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
      ),
    );
  }
}
