import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import 'room_service.dart';

class ChatService {
  ChatService(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<List<ChatMessage>> watchMessages(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return ChatMessage(
              author: data['author'] as String,
              message: data['message'] as String,
              timestamp:
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              isSystem: (data['isSystem'] ?? false) as bool,
            );
          }).toList(),
        );
  }

  Future<void> sendMessage({
    required String roomId,
    required String author,
    required String message,
    bool isSystem = false,
  }) {
    return _firestore.collection('rooms').doc(roomId).collection('messages').add({
      'author': author,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
      'isSystem': isSystem,
    });
  }
}

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService(ref.read(firestoreProvider));
});
