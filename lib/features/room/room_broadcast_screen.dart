import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/signaling_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/status_banner.dart';
import 'controllers/room_controller.dart';
import 'room_widgets.dart';

class RoomBroadcastScreen extends ConsumerStatefulWidget {
  const RoomBroadcastScreen({super.key});

  @override
  ConsumerState<RoomBroadcastScreen> createState() => _RoomBroadcastScreenState();
}

class _RoomBroadcastScreenState extends ConsumerState<RoomBroadcastScreen> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  String? _callId;
  bool _connecting = false;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _localRenderer.initialize();
    _remoteRenderer.initialize();
  }

  Future<void> _initLocalStream() async {
    _localStream = await navigator.mediaDevices.getDisplayMedia({
      'video': true,
      'audio': false,
    });
    _localRenderer.srcObject = _localStream;
  }

  Future<void> _createPeerConnection(String roomId, String role) async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };
    _peerConnection = await createPeerConnection(configuration);
    _peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams.first;
        _remoteRenderer.srcObject = _remoteStream;
      }
    };
    _peerConnection!.onIceCandidate = (candidate) {
      if (_callId == null) return;
      ref.read(signalingServiceProvider).addIceCandidate(
            roomId: roomId,
            callId: _callId!,
            role: role,
            candidate: candidate.toMap(),
          );
    };
    if (_localStream != null) {
      for (final track in _localStream!.getTracks()) {
        await _peerConnection!.addTrack(track, _localStream!);
      }
    }
  }

  Future<void> _startBroadcast(String roomId) async {
    setState(() => _connecting = true);
    await _initLocalStream();
    await _createPeerConnection(roomId, 'broadcaster');
    final callDoc = await ref.read(signalingServiceProvider).createCall(
          roomId: roomId,
          from: 'broadcaster',
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
        .watchIceCandidates(roomId: roomId, callId: _callId!, role: 'viewer')
        .listen((snapshot) {
      for (final doc in snapshot.docs) {
        _peerConnection?.addCandidate(RTCIceCandidate(
          doc['candidate'],
          doc['sdpMid'],
          doc['sdpMLineIndex'],
        ));
      }
    });
    ref.read(signalingServiceProvider).watchOffers(roomId).listen((snapshot) async {
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
    setState(() => _connecting = false);
  }

  Future<void> _joinBroadcast(String roomId) async {
    setState(() => _connecting = true);
    await _createPeerConnection(roomId, 'viewer');
    ref.read(signalingServiceProvider).watchOffers(roomId).listen((snapshot) async {
      if (snapshot.docs.isEmpty) return;
      if (_callId != null) return;
      final doc = snapshot.docs.first;
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
          .watchIceCandidates(roomId: roomId, callId: _callId!, role: 'broadcaster')
          .listen((snapshot) {
        for (final doc in snapshot.docs) {
          _peerConnection?.addCandidate(RTCIceCandidate(
            doc['candidate'],
            doc['sdpMid'],
            doc['sdpMLineIndex'],
          ));
        }
      });
      setState(() => _connecting = false);
    });
  }

  Future<void> _endBroadcast() async {
    await _peerConnection?.close();
    await _localStream?.dispose();
    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;
    setState(() {
      _peerConnection = null;
      _localStream = null;
      _remoteStream = null;
      _callId = null;
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityAsync = ref.watch(connectivityProvider);
    final isOffline = connectivityAsync.value?.isOffline ?? false;
    final roomAsync = ref.watch(activeRoomProvider);
    return GradientScaffold(
      appBar: AppBar(title: const Text('Transmissão de Tela')),
      bottomNavigationBar: const RoomDock(),
      child: roomAsync.when(
        data: (roomState) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (isOffline)
              const StatusBanner(
                message: 'Sem conexão. Tentando reconectar…',
                color: Colors.redAccent,
                icon: Icons.wifi_off,
              ),
            if (roomState.room.hostDisconnected)
              const StatusBanner(
                message: 'Host desconectado… aguardando reconexão.',
                color: Colors.orangeAccent,
                icon: Icons.person_off,
              ),
            SizedBox(
              height: 200,
              child: RTCVideoView(_remoteRenderer),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: RTCVideoView(_localRenderer, mirror: true),
            ),
            const SizedBox(height: 12),
            const Text('Aviso: conteúdos protegidos por DRM podem falhar.'),
            const SizedBox(height: 16),
            AppButton(
              label: 'Iniciar transmissão',
              onPressed: _connecting ? null : () => _startBroadcast(roomState.roomId),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Entrar na transmissão',
              onPressed: _connecting ? null : () => _joinBroadcast(roomState.roomId),
              isOutlined: true,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Parar transmissão',
              onPressed: _endBroadcast,
              isOutlined: true,
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
