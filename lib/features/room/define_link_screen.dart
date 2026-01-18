import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/chat_service.dart';
import '../../core/services/room_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/utils/validators.dart';
import 'controllers/room_controller.dart';

class DefineLinkScreen extends ConsumerStatefulWidget {
  const DefineLinkScreen({super.key});

  @override
  ConsumerState<DefineLinkScreen> createState() => _DefineLinkScreenState();
}

class _DefineLinkScreenState extends ConsumerState<DefineLinkScreen> {
  final controller = TextEditingController();
  String? linkType;

  Future<void> _detect(String roomId) async {
    final type = detectLinkType(controller.text.trim());
    setState(() => linkType = type);
    await ref.read(roomServiceProvider).updateContentUrl(roomId, controller.text.trim());
    await ref.read(chatServiceProvider).sendMessage(
          roomId: roomId,
          author: 'Sistema',
          message: 'Conteúdo definido ($type).',
          isSystem: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    final roomId = ref.watch(activeRoomIdProvider);
    if (roomId == null) {
      return const GradientScaffold(child: Center(child: Text('Nenhuma sala ativa.')));
    }
    return GradientScaffold(
      appBar: AppBar(title: const Text('Definir Link')),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppTextField(
              label: 'Link do conteúdo',
              controller: controller,
              hint: 'https://youtube.com/…',
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Detectar',
              onPressed: () => _detect(roomId),
              isOutlined: true,
            ),
            const SizedBox(height: 16),
            if (linkType != null)
              GlassContainer(
                child: Row(
                  children: [
                    const Icon(Icons.play_circle_outline, size: 42),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tipo detectado: $linkType'),
                          const SizedBox(height: 4),
                          const Text('Prévia simulada do conteúdo'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            AppButton(
              label: 'Salvar e voltar',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
