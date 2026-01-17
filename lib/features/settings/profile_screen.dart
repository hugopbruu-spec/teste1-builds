import 'package:flutter/material.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/gradient_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Perfil')),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
            const SizedBox(height: 16),
            const AppTextField(label: 'Nome', hint: 'Seu nome'),
            const SizedBox(height: 16),
            const AppTextField(label: 'Username', hint: '@seuuser'),
            const SizedBox(height: 24),
            AppButton(label: 'Salvar alterações', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
