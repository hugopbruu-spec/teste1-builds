class ChatMessage {
  const ChatMessage({
    required this.author,
    required this.message,
    required this.timestamp,
    this.isSystem = false,
  });

  final String author;
  final String message;
  final DateTime timestamp;
  final bool isSystem;
}
