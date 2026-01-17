import 'package:flutter/material.dart';
import '../../core/widgets/gradient_scaffold.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Histórico')),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _HistoryTile(title: 'Sessão com Lia', subtitle: 'YouTube • 1h atrás'),
          _HistoryTile(title: 'Navegação conjunta', subtitle: 'Web • ontem'),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
