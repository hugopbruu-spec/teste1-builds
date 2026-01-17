enum RoomMode { synced, coBrowsing, broadcast }

class RoomInfo {
  const RoomInfo({
    required this.code,
    required this.mode,
    required this.hostName,
    this.hostDisconnected = false,
  });

  final String code;
  final RoomMode mode;
  final String hostName;
  final bool hostDisconnected;

  String get modeLabel {
    switch (mode) {
      case RoomMode.synced:
        return 'Sincronizado';
      case RoomMode.coBrowsing:
        return 'Navegação Conjunta';
      case RoomMode.broadcast:
        return 'Transmissão';
    }
  }
}
