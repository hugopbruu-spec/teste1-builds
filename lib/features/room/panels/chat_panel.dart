import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/chat_message.dart';
import '../../../core/services/chat_service.dart';
import '../controllers/room_controller.dart';
import '../../../core/widgets/app_button.dart';

class ChatPanel extends ConsumerStatefulWidget {
  const ChatPanel({super.key});

  @override
  ConsumerState<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends ConsumerState<ChatPanel> {
  final controller = TextEditingController();
  bool cooldown = false;

  Future<void> _send(String roomId) async {
    final text = controller.text.trim();
    if (text.isEmpty || cooldown) return;
    setState(() {
      cooldown = true;
      controller.clear();
    });
    await ref.read(roomActionsProvider).sendChatMessage(roomId, text);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => cooldown = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomId = ref.watch(activeRoomIdProvider);
    if (roomId == null) {
      return const Text('Nenhuma sala ativa.');
    }
    return StreamBuilder<List<ChatMessage>>(
      stream: ref.read(chatServiceProvider).watchMessages(roomId),
      builder: (context, snapshot) {
        final messages = snapshot.data ?? [];
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final ChatMessage message = messages[index];
                return ListTile(
                  title: Text(
                    message.author,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: message.isSystem ? Colors.orangeAccent : Colors.white,
                    ),
                  ),
                  subtitle: Text(message.message),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Enviar mensagem'),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: cooldown ? 'Aguarde…' : 'Enviar',
              onPressed: cooldown ? null : () => _send(roomId),
            ),
          ],
        );
      },
    );
  }
}
