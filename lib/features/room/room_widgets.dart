import 'package:flutter/material.dart';
import '../../core/widgets/panel_sheet.dart';
import 'panels/chat_panel.dart';
import 'panels/participants_panel.dart';
import 'panels/voice_panel.dart';
import 'panels/options_panel.dart';

class RoomDock extends StatelessWidget {
  const RoomDock({super.key});

  void _openPanel(BuildContext context, Widget panel, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, controller) => PanelSheet(
          title: title,
          child: SingleChildScrollView(
            controller: controller,
            child: panel,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF12172D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _DockButton(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            onTap: () => _openPanel(context, const ChatPanel(), 'Chat'),
          ),
          _DockButton(
            icon: Icons.mic_none,
            label: 'Voz',
            onTap: () => _openPanel(context, const VoicePanel(), 'Voz'),
          ),
          _DockButton(
            icon: Icons.group_outlined,
            label: 'Participantes',
            onTap: () =>
                _openPanel(context, const ParticipantsPanel(), 'Participantes'),
          ),
          _DockButton(
            icon: Icons.more_horiz,
            label: 'Opções',
            onTap: () => _openPanel(context, const OptionsPanel(), 'Opções'),
          ),
        ],
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  const _DockButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
