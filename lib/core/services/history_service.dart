import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/history_item.dart';
import 'room_service.dart';

class HistoryService {
  HistoryService(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<List<HistoryItem>> watchHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => HistoryItem(
                  title: doc['title'] as String,
                  subtitle: doc['subtitle'] as String,
                  timestampLabel: doc['timestampLabel'] as String,
                ),
              )
              .toList(),
        );
  }
}

final historyServiceProvider = Provider<HistoryService>((ref) {
  return HistoryService(ref.read(firestoreProvider));
});
