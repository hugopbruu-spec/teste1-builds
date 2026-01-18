import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/widgets/gradient_scaffold.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authServiceProvider).currentUser;
    if (user == null) {
      return const GradientScaffold(child: Center(child: Text('Faça login.')));
    }
    return GradientScaffold(
      appBar: AppBar(title: const Text('Notificações')),
      child: StreamBuilder(
        stream: ref.read(notificationServiceProvider).watchNotifications(user.uid),
        builder: (context, snapshot) {
          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            return const Center(child: Text('Sem notificações.'));
          }
          return ListView(
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
          );
        },
      ),
    );
  }
}
