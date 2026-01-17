import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';

class ChatRepository extends StateNotifier<List<ChatMessage>> {
  ChatRepository()
      : super([
          ChatMessage(
            author: 'Sistema',
            message: 'Sala criada',
            timestamp: DateTime.now(),
            isSystem: true,
          ),
          ChatMessage(
            author: 'Lia',
            message: 'Bem-vindos!',
            timestamp: DateTime.now(),
          ),
        ]);

  void sendMessage(String author, String message) {
    state = [
      ...state,
      ChatMessage(author: author, message: message, timestamp: DateTime.now()),
    ];
  }

  void sendSystemMessage(String message) {
    state = [
      ...state,
      ChatMessage(
        author: 'Sistema',
        message: message,
        timestamp: DateTime.now(),
        isSystem: true,
      ),
    ];
  }
}

final chatRepositoryProvider =
    StateNotifierProvider<ChatRepository, List<ChatMessage>>(
  (ref) => ChatRepository(),
);
