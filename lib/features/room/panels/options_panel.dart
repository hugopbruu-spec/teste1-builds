import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/chat_service.dart';
import '../../../core/services/room_service.dart';
import '../controllers/room_controller.dart';

class OptionsPanel extends ConsumerStatefulWidget {
  const OptionsPanel({super.key});

  @override
  ConsumerState<OptionsPanel> createState() => _OptionsPanelState();
}

class _OptionsPanelState extends ConsumerState<OptionsPanel> {
  bool? allowChat;
  bool? allowVoice;
  bool? requireApproval;

  void _notify(String message, String roomId) {
    ref.read(chatServiceProvider).sendMessage(
          roomId: roomId,
          author: 'Sistema',
          message: message,
          isSystem: true,
        );
  }

  Future<void> _updatePermissions(String roomId) {
    return ref.read(roomServiceProvider).updatePermissions(
          roomId: roomId,
          allowChat: allowChat ?? true,
          allowVoice: allowVoice ?? true,
          requireApproval: requireApproval ?? false,
        );
  }

  @override
  Widget build(BuildContext context) {
    final roomAsync = ref.watch(activeRoomProvider);
    return roomAsync.when(
      data: (roomState) {
        allowChat ??= roomState.room.permissions.allowChat;
        allowVoice ??= roomState.room.permissions.allowVoice;
        requireApproval ??= roomState.room.permissions.requireApproval;
        final canEdit = roomState.isHost;
        final roomId = roomState.roomId;
        return Column(
          children: [
            if (!canEdit)
              const ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Apenas o host pode alterar permissões.'),
              ),
            SwitchListTile(
              value: allowChat ?? true,
              onChanged: canEdit
                  ? (value) async {
                      setState(() => allowChat = value);
                      await _updatePermissions(roomId);
                      _notify(
                        value ? 'Chat liberado pelo host.' : 'Chat desativado pelo host.',
                        roomId,
                      );
                    }
                  : null,
              title: const Text('Permitir chat'),
            ),
            SwitchListTile(
              value: allowVoice ?? true,
              onChanged: canEdit
                  ? (value) async {
                      setState(() => allowVoice = value);
                      await _updatePermissions(roomId);
                      _notify(
                        value ? 'Voz liberada pelo host.' : 'Voz desativada pelo host.',
                        roomId,
                      );
                    }
                  : null,
              title: const Text('Permitir voz'),
            ),
            SwitchListTile(
              value: requireApproval ?? false,
              onChanged: canEdit
                  ? (value) async {
                      setState(() => requireApproval = value);
                      await _updatePermissions(roomId);
                      _notify(
                        value
                            ? 'Entrada agora precisa de aprovação.'
                            : 'Entrada liberada sem aprovação.',
                        roomId,
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
              onTap: canEdit
                  ? () => ref.read(roomServiceProvider).endRoom(roomId)
                  : null,
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erro: $error')),
    );
  }
}
