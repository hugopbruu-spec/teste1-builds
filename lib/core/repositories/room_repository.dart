import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/participant.dart';
import '../models/room.dart';

class RoomState {
  const RoomState({
    required this.room,
    required this.participants,
    required this.isHost,
  });

  final RoomInfo room;
  final List<Participant> participants;
  final bool isHost;

  RoomState copyWith({
    RoomInfo? room,
    List<Participant>? participants,
    bool? isHost,
  }) {
    return RoomState(
      room: room ?? this.room,
      participants: participants ?? this.participants,
      isHost: isHost ?? this.isHost,
    );
  }
}

class RoomRepository extends StateNotifier<RoomState> {
  RoomRepository()
      : super(
          RoomState(
            room: const RoomInfo(
              code: 'A7K9Q',
              mode: RoomMode.synced,
              hostName: 'Lia',
            ),
            isHost: true,
            participants: const [
              Participant(
                name: 'Lia',
                role: ParticipantRole.host,
                status: ParticipantStatus.online,
              ),
              Participant(
                name: 'João',
                role: ParticipantRole.guest,
                status: ParticipantStatus.online,
              ),
              Participant(
                name: 'Camila',
                role: ParticipantRole.guest,
                status: ParticipantStatus.buffering,
              ),
              Participant(
                name: 'Rafa',
                role: ParticipantRole.guest,
                status: ParticipantStatus.offline,
              ),
            ],
          ),
        );

  void updateMode(RoomMode mode) {
    state = state.copyWith(
      room: RoomInfo(
        code: state.room.code,
        mode: mode,
        hostName: state.room.hostName,
        hostDisconnected: state.room.hostDisconnected,
      ),
    );
  }

  void toggleHostDisconnected(bool value) {
    state = state.copyWith(
      room: RoomInfo(
        code: state.room.code,
        mode: state.room.mode,
        hostName: state.room.hostName,
        hostDisconnected: value,
      ),
    );
  }

  void setRole(bool isHost) {
    state = state.copyWith(isHost: isHost);
  }
}

final roomRepositoryProvider =
    StateNotifierProvider<RoomRepository, RoomState>((ref) {
  return RoomRepository();
});
