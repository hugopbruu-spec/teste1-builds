import 'package:flutter/material.dart';
import '../../../core/utils/fake_data.dart';
import '../../../core/widgets/status_badge.dart';

class ParticipantsPanel extends StatelessWidget {
  const ParticipantsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: fakeParticipants
          .map(
            (participant) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(participant['name']!),
              subtitle: Text(participant['status']!),
              trailing: StatusBadge(
                label: participant['role']!,
                color: participant['role'] == 'Host' ? Colors.greenAccent : null,
              ),
            ),
          )
          .toList(),
    );
  }
}
