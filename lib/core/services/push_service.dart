import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';
import 'room_service.dart';

class PushService {
  PushService(this._messaging, this._auth, this._firestore);

  final FirebaseMessaging _messaging;
  final AuthService _auth;
  final FirebaseFirestore _firestore;

  Future<void> registerToken() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final token = await _messaging.getToken();
    if (token == null) return;
    await _firestore.collection('users').doc(user.uid).set({
      'fcmToken': token,
    }, SetOptions(merge: true));
  }
}

final pushServiceProvider = Provider<PushService>((ref) {
  return PushService(
    FirebaseMessaging.instance,
    ref.read(authServiceProvider),
    ref.read(firestoreProvider),
  );
});
