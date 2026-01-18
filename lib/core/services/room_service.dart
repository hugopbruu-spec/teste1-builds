import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/participant.dart';
import '../models/room.dart';
import '../models/sync_state.dart';

class RoomService {
  RoomService(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _rooms =>
      _firestore.collection('rooms');

  Future<String> createRoom({
    required String hostId,
    required String hostName,
    required RoomMode mode,
  }) async {
    final code = _generateCode();
    final doc = _rooms.doc();
    final now = FieldValue.serverTimestamp();
    await doc.set({
      'code': code,
      'mode': mode.name,
      'hostId': hostId,
      'hostName': hostName,
      'contentUrl': '',
      'status': 'active',
      'createdAt': now,
      'hostDisconnected': false,
      'permissions': {
        'allowChat': true,
        'allowVoice': true,
        'requireApproval': false,
      },
    });
    await doc.collection('participants').doc(hostId).set({
      'name': hostName,
      'role': ParticipantRole.host.name,
      'status': ParticipantStatus.online.name,
      'joinedAt': now,
      'lastActive': now,
    });
    await doc.collection('sync').doc('state').set({
      'isPlaying': false,
      'positionMs': 0,
      'updatedAt': now,
    });
    return doc.id;
  }

  Future<String?> findRoomIdByCode(String code) async {
    final snapshot = await _rooms.where('code', isEqualTo: code).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.id;
  }

  Stream<RoomInfo> watchRoom(String roomId) {
    return _rooms.doc(roomId).snapshots().map((doc) {
      final data = doc.data()!;
      final permissions = data['permissions'] as Map<String, dynamic>? ?? {};
      return RoomInfo(
        code: data['code'] as String,
        mode: RoomMode.values.firstWhere((e) => e.name == data['mode']),
        hostId: data['hostId'] as String,
        hostName: data['hostName'] as String,
        contentUrl: (data['contentUrl'] ?? '') as String,
        hostDisconnected: (data['hostDisconnected'] ?? false) as bool,
        permissions: RoomPermissions(
          allowChat: (permissions['allowChat'] ?? true) as bool,
          allowVoice: (permissions['allowVoice'] ?? true) as bool,
          requireApproval: (permissions['requireApproval'] ?? false) as bool,
        ),
      );
    });
  }

  Stream<List<Participant>> watchParticipants(String roomId) {
    return _rooms.doc(roomId).collection('participants').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) {
                final data = doc.data();
                return Participant(
                  id: doc.id,
                  name: data['name'] as String,
                  role: ParticipantRole.values.firstWhere(
                    (e) => e.name == data['role'],
                  ),
                  status: ParticipantStatus.values.firstWhere(
                    (e) => e.name == data['status'],
                  ),
                );
              })
              .toList(),
        );
  }

  Stream<RoomSyncState> watchSyncState(String roomId) {
    return _rooms.doc(roomId).collection('sync').doc('state').snapshots().map(
      (doc) {
        final data = doc.data()!;
        return RoomSyncState(
          isPlaying: data['isPlaying'] as bool,
          positionMs: data['positionMs'] as int,
          updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      },
    );
  }

  Future<void> updateSyncState({
    required String roomId,
    required bool isPlaying,
    required int positionMs,
  }) {
    return _rooms.doc(roomId).collection('sync').doc('state').set({
      'isPlaying': isPlaying,
      'positionMs': positionMs,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> joinRoom({
    required String roomId,
    required String userId,
    required String name,
  }) async {
    final now = FieldValue.serverTimestamp();
    await _rooms.doc(roomId).collection('participants').doc(userId).set({
      'name': name,
      'role': ParticipantRole.guest.name,
      'status': ParticipantStatus.online.name,
      'joinedAt': now,
      'lastActive': now,
    });
  }

  Future<void> leaveRoom({
    required String roomId,
    required String userId,
  }) {
    return _rooms.doc(roomId).collection('participants').doc(userId).delete();
  }

  Future<void> endRoom(String roomId) {
    return _rooms.doc(roomId).update({
      'status': 'ended',
    });
  }

  Future<void> updateHostDisconnected(String roomId, bool value) {
    return _rooms.doc(roomId).update({'hostDisconnected': value});
  }

  Future<void> updateContentUrl(String roomId, String url) {
    return _rooms.doc(roomId).update({'contentUrl': url});
  }

  Future<void> updatePermissions({
    required String roomId,
    required bool allowChat,
    required bool allowVoice,
    required bool requireApproval,
  }) {
    return _rooms.doc(roomId).update({
      'permissions': {
        'allowChat': allowChat,
        'allowVoice': allowVoice,
        'requireApproval': requireApproval,
      },
    });
  }

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random();
    return List.generate(5, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final roomServiceProvider = Provider<RoomService>((ref) {
  return RoomService(ref.read(firestoreProvider));
});
