import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/tokens.dart';

enum SyncStatusType { synced, adjusting, outOfSync }

class SyncStatus {
  const SyncStatus({
    required this.type,
    required this.message,
    this.nudgeMs,
    this.seekDelta,
    this.color,
  });

  final SyncStatusType type;
  final String message;
  final int? nudgeMs;
  final Duration? seekDelta;
  final Color? color;

  SyncStatus copyWith({
    SyncStatusType? type,
    String? message,
    int? nudgeMs,
    Duration? seekDelta,
    Color? color,
  }) {
    return SyncStatus(
      type: type ?? this.type,
      message: message ?? this.message,
      nudgeMs: nudgeMs ?? this.nudgeMs,
      seekDelta: seekDelta ?? this.seekDelta,
      color: color ?? this.color,
    );
  }
}

class SyncEngine extends StateNotifier<SyncStatus> {
  SyncEngine()
      : super(
          const SyncStatus(
            type: SyncStatusType.synced,
            message: 'Sincronizado ✓',
            color: AppTokens.success,
          ),
        );

  void simulateAdjusting() {
    state = const SyncStatus(
      type: SyncStatusType.adjusting,
      message: 'Ajustando…',
      color: AppTokens.warning,
      nudgeMs: 180,
    );
  }

  void simulateOutOfSync() {
    state = const SyncStatus(
      type: SyncStatusType.outOfSync,
      message: 'Fora de sync',
      color: AppTokens.danger,
      seekDelta: Duration(seconds: 2),
    );
  }

  void resyncNow() {
    state = const SyncStatus(
      type: SyncStatusType.synced,
      message: 'Sincronizado ✓',
      color: AppTokens.success,
    );
  }
}

final syncEngineProvider = StateNotifierProvider<SyncEngine, SyncStatus>(
  (ref) => SyncEngine(),
);
