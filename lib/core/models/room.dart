enum RoomMode { synced, coBrowsing, broadcast }

class RoomPermissions {
  const RoomPermissions({
    required this.allowChat,
    required this.allowVoice,
    required this.requireApproval,
  });

  final bool allowChat;
  final bool allowVoice;
  final bool requireApproval;
}

class RoomInfo {
  const RoomInfo({
    required this.code,
    required this.mode,
    required this.hostId,
    required this.hostName,
    required this.permissions,
    required this.contentUrl,
    this.hostDisconnected = false,
  });

  final String code;
  final RoomMode mode;
  final String hostId;
  final String hostName;
  final RoomPermissions permissions;
  final String contentUrl;
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
