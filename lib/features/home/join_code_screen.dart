import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../room/controllers/room_controller.dart';

class JoinCodeScreen extends ConsumerStatefulWidget {
  const JoinCodeScreen({super.key});

  @override
  ConsumerState<JoinCodeScreen> createState() => _JoinCodeScreenState();
}

class _JoinCodeScreenState extends ConsumerState<JoinCodeScreen> {
  final controller = TextEditingController();
  String? error;
  bool isLoading = false;

  Future<void> _join() async {
    final input = controller.text.trim().toUpperCase();
    if (!isValidRoomCode(input)) {
      setState(() => error = 'Código inválido');
      return;
    }
    setState(() {
      error = null;
      isLoading = true;
    });
    final roomId = await ref.read(roomActionsProvider).joinRoomByCode(input);
    if (roomId == null || roomId.isEmpty) {
      setState(() {
        error = 'Sala não encontrada';
        isLoading = false;
      });
      return;
    }
    ref.read(activeRoomIdProvider.notifier).state = roomId;
    if (mounted) context.go('/lobby');
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Entrar com código')),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppTextField(
              label: 'Código da sala',
              controller: controller,
              hint: 'A7K9Q',
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 24),
            AppButton(
              label: 'Entrar',
              onPressed: isLoading ? null : _join,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
