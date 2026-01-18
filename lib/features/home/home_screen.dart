import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authServiceProvider).currentUser;
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            onPressed: () => context.go('/notifications'),
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo, ${user?.email ?? 'usuário'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text('Pronto para assistir algo com a galera?'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Criar sala',
            icon: Icons.add_circle_outline,
            onPressed: () => context.go('/create-room'),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Entrar com código',
            icon: Icons.meeting_room_outlined,
            onPressed: () => context.go('/join-code'),
            isOutlined: true,
          ),
          const SizedBox(height: 24),
          Text('Atalhos', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ShortcutCard(
                title: 'Histórico',
                icon: Icons.history,
                onTap: () => context.go('/history'),
              ),
              _ShortcutCard(
                title: 'Perfil',
                icon: Icons.person_outline,
                onTap: () => context.go('/profile'),
              ),
              _ShortcutCard(
                title: 'Configurações',
                icon: Icons.settings_outlined,
                onTap: () => context.go('/settings'),
              ),
              _ShortcutCard(
                title: 'Ajuda',
                icon: Icons.help_outline,
                onTap: () => context.go('/settings/help'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
