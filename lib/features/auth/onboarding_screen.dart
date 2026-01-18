import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/gradient_scaffold.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int pageIndex = 0;

  final pages = const [
    _OnboardingPage(
      title: 'Sincronize conteúdo',
      description: 'Play, pause e seek alinhados com seus amigos.',
    ),
    _OnboardingPage(
      title: 'Navegação conjunta',
      description: 'Um host guia o navegador e todos acompanham.',
    ),
    _OnboardingPage(
      title: 'Transmissão ao vivo',
      description: 'Compartilhe a tela para mostrar qualquer coisa.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (value) => setState(() => pageIndex = value),
                children: pages,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == pageIndex ? Colors.white : Colors.white24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: pageIndex == pages.length - 1 ? 'Começar' : 'Próximo',
              onPressed: () {
                if (pageIndex == pages.length - 1) {
                  context.go('/login');
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              },
            ),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Pular'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(32),
          ),
          child: const Icon(Icons.play_circle, size: 72),
        ),
        const SizedBox(height: 32),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(description, textAlign: TextAlign.center),
      ],
    );
  }
}
