import 'package:flutter/material.dart';
import '../../core/widgets/gradient_scaffold.dart';

class AudioVideoScreen extends StatefulWidget {
  const AudioVideoScreen({super.key});

  @override
  State<AudioVideoScreen> createState() => _AudioVideoScreenState();
}

class _AudioVideoScreenState extends State<AudioVideoScreen> {
  bool pushToTalk = true;
  bool noiseSuppression = true;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Áudio & Vídeo')),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SwitchListTile(
            title: const Text('Push-to-talk recomendado'),
            value: pushToTalk,
            onChanged: (value) => setState(() => pushToTalk = value),
          ),
          SwitchListTile(
            title: const Text('Supressão de ruído'),
            value: noiseSuppression,
            onChanged: (value) => setState(() => noiseSuppression = value),
          ),
          ListTile(
            title: const Text('Dispositivo de saída'),
            subtitle: const Text('Padrão do sistema'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
