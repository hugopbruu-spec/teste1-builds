import 'package:flutter/material.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/gradient_scaffold.dart';
import 'room_widgets.dart';

class RoomBrowseScreen extends StatelessWidget {
  const RoomBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Navegação Conjunta')),
      bottomNavigationBar: const RoomDock(),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Navegador do host'),
                const SizedBox(height: 8),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Icon(Icons.public, size: 64)),
                ),
                const SizedBox(height: 12),
                const Text('URL sincronizada: https://example.com'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Abrir navegador interno',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Sincronizar scroll agora',
            onPressed: () {},
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}
