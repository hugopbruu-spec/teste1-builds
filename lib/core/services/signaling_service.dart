import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignalingService {
  SignalingService(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _calls(String roomId) {
    return _firestore.collection('rooms').doc(roomId).collection('calls');
  }

  Future<DocumentReference<Map<String, dynamic>>> createCall({
    required String roomId,
    required String from,
  }) {
    return _calls(roomId).add({
      'from': from,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchOffers(String roomId) {
    return _calls(roomId).where('offer', isNull: false).snapshots();
  }

  Future<void> setOffer({
    required String roomId,
    required String callId,
    required Map<String, dynamic> offer,
  }) {
    return _calls(roomId).doc(callId).set({'offer': offer}, SetOptions(merge: true));
  }

  Future<void> setAnswer({
    required String roomId,
    required String callId,
    required Map<String, dynamic> answer,
  }) {
    return _calls(roomId).doc(callId).set({'answer': answer}, SetOptions(merge: true));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchIceCandidates({
    required String roomId,
    required String callId,
    required String role,
  }) {
    return _calls(roomId)
        .doc(callId)
        .collection('candidates-$role')
        .snapshots();
  }

  Future<void> addIceCandidate({
    required String roomId,
    required String callId,
    required String role,
    required Map<String, dynamic> candidate,
  }) {
    return _calls(roomId)
        .doc(callId)
        .collection('candidates-$role')
        .add(candidate);
  }
}

final signalingServiceProvider = Provider<SignalingService>((ref) {
  return SignalingService(ref.read(firestoreProvider));
});
