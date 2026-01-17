import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/room_repository.dart';
import '../../../core/widgets/status_badge.dart';

class ParticipantsPanel extends ConsumerWidget {
  const ParticipantsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomState = ref.watch(roomRepositoryProvider);
    return Column(
      children: roomState.participants
          .map(
            (participant) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(participant.name),
              subtitle: Text(participant.statusLabel),
              trailing: StatusBadge(
                label: participant.roleLabel,
                color: participant.role == ParticipantRole.host
                    ? Colors.greenAccent
                    : null,
              ),
            ),
          )
          .toList(),
    );
  }
}
