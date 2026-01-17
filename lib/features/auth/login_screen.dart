import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/gradient_scaffold.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Entrar')),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppButton(
              label: 'Continuar com Google',
              icon: Icons.g_mobiledata,
              onPressed: () => context.go('/home'),
              isOutlined: true,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Continuar com Apple',
              icon: Icons.apple,
              onPressed: () => context.go('/home'),
              isOutlined: true,
            ),
            const SizedBox(height: 24),
            const AppTextField(label: 'Email', hint: 'voce@exemplo.com'),
            const SizedBox(height: 16),
            const AppTextField(label: 'Senha', obscureText: true),
            const SizedBox(height: 24),
            AppButton(
              label: 'Entrar',
              onPressed: () => context.go('/home'),
            ),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
