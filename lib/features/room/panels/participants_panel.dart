import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/participant.dart';
import '../../../core/widgets/status_badge.dart';
import '../controllers/room_controller.dart';

class ParticipantsPanel extends ConsumerWidget {
  const ParticipantsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(activeRoomProvider);
    return roomAsync.when(
      data: (roomState) => Column(
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
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erro: $error')),
    );
  }
}
