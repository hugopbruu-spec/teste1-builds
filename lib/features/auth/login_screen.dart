import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/gradient_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSignup = false;
  String? error;
  bool isLoading = false;

  Future<void> _submit() async {
    setState(() {
      error = null;
      isLoading = true;
    });
    final auth = ref.read(authServiceProvider);
    try {
      if (isSignup) {
        await auth.signUp(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        await auth.signIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      }
      if (mounted) context.go('/home');
    } catch (e) {
      setState(() => error = 'Falha na autenticação.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: Text(isSignup ? 'Criar conta' : 'Entrar')),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppTextField(
              label: 'Email',
              controller: emailController,
              hint: 'voce@exemplo.com',
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Senha',
              controller: passwordController,
              obscureText: true,
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 24),
            AppButton(
              label: isSignup ? 'Criar conta' : 'Entrar',
              onPressed: isLoading ? null : _submit,
              isLoading: isLoading,
            ),
            TextButton(
              onPressed: () => setState(() => isSignup = !isSignup),
              child: Text(isSignup ? 'Já tenho conta' : 'Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
