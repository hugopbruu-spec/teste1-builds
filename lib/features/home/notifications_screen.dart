import 'package:flutter/material.dart';
import '../../core/widgets/gradient_scaffold.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Notificações')),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _NotificationTile(title: 'Lia criou uma sala', subtitle: 'Convite para assistir junto'),
          _NotificationTile(title: 'Rafa entrou na sala', subtitle: 'Modo sincronizado ativo'),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.title, required this.subtitle});

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
