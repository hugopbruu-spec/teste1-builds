import 'package:flutter/material.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';
import 'room_widgets.dart';

class RoomBroadcastScreen extends StatelessWidget {
  const RoomBroadcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Transmissão de Tela')),
      bottomNavigationBar: const RoomDock(),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tela do host'),
                const SizedBox(height: 8),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Icon(Icons.cast, size: 64)),
                ),
                const SizedBox(height: 12),
                const Text('Aviso: conteúdos protegidos por DRM podem falhar.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Iniciar transmissão',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Parar transmissão',
            onPressed: () {},
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}
