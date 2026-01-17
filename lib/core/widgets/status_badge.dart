import 'package:flutter/material.dart';
import '../../app/theme/tokens.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.color,
  });

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? AppTokens.success).withOpacity(0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: (color ?? AppTokens.success)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color ?? AppTokens.success,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
