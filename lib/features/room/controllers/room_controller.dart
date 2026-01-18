import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/models/participant.dart';
import '../../../core/models/room.dart';
import '../../../core/models/sync_state.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/chat_service.dart';
import '../../../core/services/room_service.dart';

class ActiveRoomState {
  const ActiveRoomState({
    required this.roomId,
    required this.room,
    required this.participants,
    required this.syncState,
    required this.isHost,
  });

  final String roomId;
  final RoomInfo room;
  final List<Participant> participants;
  final RoomSyncState syncState;
  final bool isHost;
}

final activeRoomIdProvider = StateProvider<String?>((ref) => null);

final activeRoomProvider = StreamProvider<ActiveRoomState>((ref) {
  final roomId = ref.watch(activeRoomIdProvider);
  if (roomId == null) {
    return const Stream.empty();
  }
  final roomService = ref.watch(roomServiceProvider);
  final auth = ref.watch(authServiceProvider);
  final userId = auth.currentUser?.uid ?? '';
  final roomStream = roomService.watchRoom(roomId);
  final participantsStream = roomService.watchParticipants(roomId);
  final syncStream = roomService.watchSyncState(roomId);
  return Rx.combineLatest3(roomStream, participantsStream, syncStream,
      (RoomInfo room, List<Participant> participants, RoomSyncState sync) {
    final isHost = userId.isNotEmpty && userId == room.hostId;
    return ActiveRoomState(
      roomId: roomId,
      room: room,
      participants: participants,
      syncState: sync,
      isHost: isHost || userId == room.hostName,
    );
  });
});

final roomActionsProvider = Provider<RoomActions>((ref) {
  return RoomActions(
    authService: ref.read(authServiceProvider),
    roomService: ref.read(roomServiceProvider),
    chatService: ref.read(chatServiceProvider),
  );
});

class RoomActions {
  RoomActions({
    required this.authService,
    required this.roomService,
    required this.chatService,
  });

  final AuthService authService;
  final RoomService roomService;
  final ChatService chatService;

  Future<String?> joinRoomByCode(String code) async {
    final roomId = await roomService.findRoomIdByCode(code);
    if (roomId == null) return null;
    final user = authService.currentUser;
    if (user == null) return null;
    await roomService.joinRoom(roomId: roomId, userId: user.uid, name: user.email ?? 'Usuário');
    await chatService.sendMessage(
      roomId: roomId,
      author: 'Sistema',
      message: '${user.email ?? 'Usuário'} entrou na sala',
      isSystem: true,
    );
    return roomId;
  }

  Future<String> createRoom(RoomMode mode) async {
    final user = authService.currentUser;
    if (user == null) {
      throw StateError('Usuário não autenticado');
    }
    final roomId = await roomService.createRoom(
      hostId: user.uid,
      hostName: user.email ?? 'Host',
      mode: mode,
    );
    return roomId;
  }

  Future<void> sendChatMessage(String roomId, String message) async {
    final user = authService.currentUser;
    if (user == null) return;
    await chatService.sendMessage(
      roomId: roomId,
      author: user.email ?? 'Usuário',
      message: message,
    );
  }

  Future<void> updateSync({
    required String roomId,
    required bool isPlaying,
    required int positionMs,
  }) {
    return roomService.updateSyncState(
      roomId: roomId,
      isPlaying: isPlaying,
      positionMs: positionMs,
    );
  }

  Future<void> leaveRoom(String roomId) async {
    final user = authService.currentUser;
    if (user == null) return;
    await roomService.leaveRoom(roomId: roomId, userId: user.uid);
    await chatService.sendMessage(
      roomId: roomId,
      author: 'Sistema',
      message: '${user.email ?? 'Usuário'} saiu da sala',
      isSystem: true,
    );
  }
}
