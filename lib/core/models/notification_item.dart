class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.subtitle,
    required this.isUnread,
  });

  final String title;
  final String subtitle;
  final bool isUnread;
}
