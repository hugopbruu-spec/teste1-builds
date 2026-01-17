import 'package:flutter/material.dart';

class OptionsPanel extends StatefulWidget {
  const OptionsPanel({super.key});

  @override
  State<OptionsPanel> createState() => _OptionsPanelState();
}

class _OptionsPanelState extends State<OptionsPanel> {
  bool allowChat = true;
  bool allowVoice = true;
  bool requireApproval = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          value: allowChat,
          onChanged: (value) => setState(() => allowChat = value),
          title: const Text('Permitir chat'),
        ),
        SwitchListTile(
          value: allowVoice,
          onChanged: (value) => setState(() => allowVoice = value),
          title: const Text('Permitir voz'),
        ),
        SwitchListTile(
          value: requireApproval,
          onChanged: (value) => setState(() => requireApproval = value),
          title: const Text('Aprovar entrada'),
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: const Text('Copiar link de convite'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.close),
          title: const Text('Encerrar sala'),
          onTap: () {},
        ),
      ],
    );
  }
}
