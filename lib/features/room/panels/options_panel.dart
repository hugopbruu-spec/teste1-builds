import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/chat_repository.dart';
import '../../../core/repositories/room_repository.dart';

class OptionsPanel extends ConsumerStatefulWidget {
  const OptionsPanel({super.key});

  @override
  ConsumerState<OptionsPanel> createState() => _OptionsPanelState();
}

class _OptionsPanelState extends ConsumerState<OptionsPanel> {
  bool allowChat = true;
  bool allowVoice = true;
  bool requireApproval = false;

  void _notify(String message) {
    ref.read(chatRepositoryProvider.notifier).sendSystemMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomRepositoryProvider);
    final canEdit = roomState.isHost;
    return Column(
      children: [
        if (!canEdit)
          const ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Apenas o host pode alterar permissões.'),
          ),
        SwitchListTile(
          value: allowChat,
          onChanged: canEdit
              ? (value) {
                  setState(() => allowChat = value);
                  _notify(value ? 'Chat liberado pelo host.' : 'Chat desativado pelo host.');
                }
              : null,
          title: const Text('Permitir chat'),
        ),
        SwitchListTile(
          value: allowVoice,
          onChanged: canEdit
              ? (value) {
                  setState(() => allowVoice = value);
                  _notify(value ? 'Voz liberada pelo host.' : 'Voz desativada pelo host.');
                }
              : null,
          title: const Text('Permitir voz'),
        ),
        SwitchListTile(
          value: requireApproval,
          onChanged: canEdit
              ? (value) {
                  setState(() => requireApproval = value);
                  _notify(
                    value
                        ? 'Entrada agora precisa de aprovação.'
                        : 'Entrada liberada sem aprovação.',
                  );
                }
              : null,
          title: const Text('Aprovar entrada'),
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: const Text('Copiar link de convite'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.close),
          title: const Text('Encerrar sala'),
          onTap: () {},
        ),
      ],
    );
  }
}
