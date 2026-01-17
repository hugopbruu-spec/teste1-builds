import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/permissions_service.dart';
import '../../../core/widgets/app_button.dart';

class VoicePanel extends ConsumerStatefulWidget {
  const VoicePanel({super.key});

  @override
  ConsumerState<VoicePanel> createState() => _VoicePanelState();
}

class _VoicePanelState extends ConsumerState<VoicePanel> {
  bool granted = false;
  bool pushToTalk = false;

  Future<void> _requestMic() async {
    final service = ref.read(permissionsProvider);
    final allowed = await service.requestMicrophone();
    if (mounted) {
      setState(() => granted = allowed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Microfone'),
          subtitle: Text(granted ? 'Permissão concedida' : 'Permissão pendente'),
          trailing: Switch(
            value: granted,
            onChanged: (_) => _requestMic(),
          ),
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Push-to-talk',
          onPressed: granted
              ? () => setState(() => pushToTalk = !pushToTalk)
              : null,
          isOutlined: !pushToTalk,
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Modo livre',
          onPressed: granted ? () {} : null,
          isOutlined: true,
        ),
      ],
    );
  }
}
