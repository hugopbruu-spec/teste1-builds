import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/fake_data.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/gradient_scaffold.dart';

class JoinCodeScreen extends StatefulWidget {
  const JoinCodeScreen({super.key});

  @override
  State<JoinCodeScreen> createState() => _JoinCodeScreenState();
}

class _JoinCodeScreenState extends State<JoinCodeScreen> {
  final controller = TextEditingController();
  String? error;

  void _join() {
    final input = controller.text.trim().toUpperCase();
    if (!isValidRoomCode(input)) {
      setState(() => error = 'Código inválido');
      return;
    }
    if (!fakeRoomCodes.contains(input)) {
      setState(() => error = 'Sala não encontrada');
      return;
    }
    setState(() => error = null);
    context.go('/lobby');
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
            AppButton(label: 'Entrar', onPressed: _join),
          ],
        ),
      ),
    );
  }
}
