import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/repositories/notification_repository.dart';
import '../../core/widgets/gradient_scaffold.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationRepositoryProvider).fetchNotifications();
    return GradientScaffold(
      appBar: AppBar(title: const Text('Notificações')),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: notifications
            .map(
              (item) => ListTile(
                title: Text(item.title),
                subtitle: Text(item.subtitle),
                trailing: item.isUnread
                    ? const Icon(Icons.circle, size: 10, color: Colors.orangeAccent)
                    : const Icon(Icons.chevron_right),
              ),
            )
            .toList(),
      ),
    );
  }
}
