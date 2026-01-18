import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/permissions_service.dart';
import '../../../core/services/signaling_service.dart';
import '../controllers/room_controller.dart';
import '../../../core/widgets/app_button.dart';

class VoicePanel extends ConsumerStatefulWidget {
  const VoicePanel({super.key});

  @override
  ConsumerState<VoicePanel> createState() => _VoicePanelState();
}

class _VoicePanelState extends ConsumerState<VoicePanel> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  String? _callId;
  bool _connecting = false;
  bool _inCall = false;

  Future<void> _initLocalStream() async {
    _localStream = await navigator.mediaDevices.getUserMedia({'audio': true});
  }

  Future<void> _createPeerConnection(String roomId) async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };
    _peerConnection = await createPeerConnection(configuration);
    if (_localStream != null) {
      for (final track in _localStream!.getTracks()) {
        await _peerConnection!.addTrack(track, _localStream!);
      }
    }
    _peerConnection!.onIceCandidate = (candidate) {
      if (_callId == null) return;
      ref.read(signalingServiceProvider).addIceCandidate(
            roomId: roomId,
            callId: _callId!,
            role: 'caller',
            candidate: candidate.toMap(),
          );
    };
  }

  Future<void> _startCall(String roomId) async {
    setState(() => _connecting = true);
    await _initLocalStream();
    await _createPeerConnection(roomId);
    final callDoc = await ref.read(signalingServiceProvider).createCall(
          roomId: roomId,
          from: ref.read(authServiceProvider).currentUser?.uid ?? 'unknown',
        );
    _callId = callDoc.id;
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    await ref.read(signalingServiceProvider).setOffer(
          roomId: roomId,
          callId: _callId!,
          offer: offer.toMap(),
        );
    ref
        .read(signalingServiceProvider)
        .watchIceCandidates(roomId: roomId, callId: _callId!, role: 'callee')
        .listen((snapshot) {
      for (final doc in snapshot.docs) {
        _peerConnection?.addCandidate(RTCIceCandidate(
          doc['candidate'],
          doc['sdpMid'],
          doc['sdpMLineIndex'],
        ));
      }
    });
    ref
        .read(signalingServiceProvider)
        .watchOffers(roomId)
        .listen((snapshot) async {
      for (final doc in snapshot.docs) {
        if (doc.id != _callId) continue;
        final data = doc.data();
        if (data['answer'] != null) {
          await _peerConnection?.setRemoteDescription(
            RTCSessionDescription(data['answer']['sdp'], data['answer']['type']),
          );
        }
      }
    });
    setState(() {
      _connecting = false;
      _inCall = true;
    });
  }

  Future<void> _joinCall(String roomId) async {
    setState(() => _connecting = true);
    await _initLocalStream();
    await _createPeerConnection(roomId);
    ref.read(signalingServiceProvider).watchOffers(roomId).listen((snapshot) async {
      if (snapshot.docs.isEmpty) return;
      final doc = snapshot.docs.first;
      if (_callId != null) return;
      _callId = doc.id;
      final data = doc.data();
      await _peerConnection?.setRemoteDescription(
        RTCSessionDescription(data['offer']['sdp'], data['offer']['type']),
      );
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      await ref.read(signalingServiceProvider).setAnswer(
            roomId: roomId,
            callId: _callId!,
            answer: answer.toMap(),
          );
      ref
          .read(signalingServiceProvider)
          .watchIceCandidates(roomId: roomId, callId: _callId!, role: 'caller')
          .listen((snapshot) {
        for (final doc in snapshot.docs) {
          _peerConnection?.addCandidate(RTCIceCandidate(
            doc['candidate'],
            doc['sdpMid'],
            doc['sdpMLineIndex'],
          ));
        }
      });
      _peerConnection!.onIceCandidate = (candidate) {
        if (_callId == null) return;
        ref.read(signalingServiceProvider).addIceCandidate(
              roomId: roomId,
              callId: _callId!,
              role: 'callee',
              candidate: candidate.toMap(),
            );
      };
      setState(() {
        _connecting = false;
        _inCall = true;
      });
    });
  }

  Future<void> _endCall() async {
    await _peerConnection?.close();
    await _localStream?.dispose();
    setState(() {
      _peerConnection = null;
      _localStream = null;
      _callId = null;
      _inCall = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomId = ref.watch(activeRoomIdProvider);
    if (roomId == null) {
      return const Text('Nenhuma sala ativa.');
    }
    return Column(
      children: [
        ListTile(
          title: const Text('Microfone'),
          subtitle: const Text('Permissão necessária para voz'),
          trailing: IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () => ref.read(permissionsProvider).requestMicrophone(),
          ),
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Iniciar chamada',
          onPressed: _connecting || _inCall ? null : () => _startCall(roomId),
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Entrar na chamada',
          onPressed: _connecting || _inCall ? null : () => _joinCall(roomId),
          isOutlined: true,
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Encerrar chamada',
          onPressed: _inCall ? _endCall : null,
          isOutlined: true,
        ),
      ],
    );
  }
}
