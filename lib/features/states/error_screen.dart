import 'package:flutter/material.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Estados & Erros')),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _ErrorCard(
            title: 'Sem internet',
            description: 'Verifique sua conexão e tente novamente.',
          ),
          _ErrorCard(
            title: 'Permissões negadas',
            description: 'Ative o microfone nas configurações do sistema.',
          ),
          _ErrorCard(
            title: 'Sala cheia ou expirada',
            description: 'Peça um novo convite ao host.',
          ),
          _ErrorCard(
            title: 'Conteúdo não suportado',
            description: 'O link não pode ser reproduzido localmente.',
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}
