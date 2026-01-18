bool isValidRoomCode(String input) {
  final regex = RegExp(r'^[A-Z0-9]{4,6}$');
  return regex.hasMatch(input.toUpperCase());
}

String detectLinkType(String url) {
  final lower = url.toLowerCase();
  if (lower.contains('youtube.com') || lower.contains('youtu.be')) {
    return 'YouTube';
  }
  if (lower.contains('tiktok.com')) {
    return 'TikTok';
  }
  return 'Web';
}
