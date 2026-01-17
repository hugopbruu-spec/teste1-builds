import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_item.dart';

class NotificationRepository {
  List<NotificationItem> fetchNotifications() {
    return const [
      NotificationItem(
        title: 'Lia criou uma sala',
        subtitle: 'Convite para assistir junto',
        isUnread: true,
      ),
      NotificationItem(
        title: 'Rafa entrou na sala',
        subtitle: 'Modo sincronizado ativo',
        isUnread: false,
      ),
    ];
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});
