import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/utils/fake_data.dart';
import '../../../core/widgets/app_button.dart';

class ChatPanel extends StatefulWidget {
  const ChatPanel({super.key});

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  final controller = TextEditingController();
  bool cooldown = false;
  final messages = [...fakeMessages];

  Future<void> _send() async {
    if (controller.text.trim().isEmpty || cooldown) return;
    setState(() {
      cooldown = true;
      messages.add({
        'author': 'Você',
        'message': controller.text.trim(),
        'system': false,
      });
      controller.clear();
    });
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => cooldown = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isSystem = message['system'] == true;
            return ListTile(
              title: Text(
                message['author']!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSystem ? Colors.orangeAccent : Colors.white,
                ),
              ),
              subtitle: Text(message['message']!),
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
          onPressed: cooldown ? null : _send,
        ),
      ],
    );
  }
}
