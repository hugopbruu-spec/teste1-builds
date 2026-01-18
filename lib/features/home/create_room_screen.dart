import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/room.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_chip.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../room/controllers/room_controller.dart';

class CreateRoomScreen extends ConsumerStatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  ConsumerState<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
  int selected = 0;
  bool isLoading = false;

  RoomMode get selectedMode {
    switch (selected) {
      case 1:
        return RoomMode.coBrowsing;
      case 2:
        return RoomMode.broadcast;
      default:
        return RoomMode.synced;
    }
  }

  Future<void> _create() async {
    setState(() => isLoading = true);
    final actions = ref.read(roomActionsProvider);
    final roomId = await actions.createRoom(selectedMode);
    if (roomId.isNotEmpty) {
      ref.read(activeRoomIdProvider.notifier).state = roomId;
      if (mounted) context.go('/lobby');
    }
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Criar Sala')),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Escolha o modo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            _ModeCard(
              selected: selected == 0,
              title: 'Modo Sincronizado',
              description: 'Cada participante reproduz localmente com sync.',
              badge: const AppChip(label: 'Recomendado'),
              onTap: () => setState(() => selected = 0),
            ),
            const SizedBox(height: 12),
            _ModeCard(
              selected: selected == 1,
              title: 'Navegação Conjunta',
              description: 'Host abre navegador e todos acompanham.',
              badge: const AppChip(label: 'Co-browsing'),
              onTap: () => setState(() => selected = 1),
            ),
            const SizedBox(height: 12),
            _ModeCard(
              selected: selected == 2,
              title: 'Transmissão de Tela',
              description: 'Compartilhe sua tela ao vivo (DRM pode falhar).',
              badge: const AppChip(label: 'AO VIVO'),
              onTap: () => setState(() => selected = 2),
            ),
            const Spacer(),
            AppButton(
              label: 'Continuar',
              onPressed: isLoading ? null : _create,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.selected,
    required this.title,
    required this.description,
    required this.badge,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String description;
  final Widget badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? Colors.white : Colors.white54,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(description, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            badge,
          ],
        ),
      ),
    );
  }
}
