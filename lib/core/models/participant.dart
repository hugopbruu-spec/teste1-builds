enum ParticipantRole { host, guest }

enum ParticipantStatus { online, buffering, offline }

class Participant {
  const Participant({
    required this.name,
    required this.role,
    required this.status,
  });

  final String name;
  final ParticipantRole role;
  final ParticipantStatus status;

  String get roleLabel => role == ParticipantRole.host ? 'Host' : 'Convidado';

  String get statusLabel {
    switch (status) {
      case ParticipantStatus.online:
        return 'Online';
      case ParticipantStatus.buffering:
        return 'Buffering';
      case ParticipantStatus.offline:
        return 'Offline';
    }
  }
}
