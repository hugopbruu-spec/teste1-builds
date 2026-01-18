class RoomSyncState {
  const RoomSyncState({
    required this.isPlaying,
    required this.positionMs,
    required this.updatedAt,
  });

  final bool isPlaying;
  final int positionMs;
  final DateTime updatedAt;
}
