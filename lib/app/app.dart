import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/auth_service.dart';
import '../core/services/push_service.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class SyncRoomApp extends ConsumerStatefulWidget {
  const SyncRoomApp({super.key});

  @override
  ConsumerState<SyncRoomApp> createState() => _SyncRoomAppState();
}

class _SyncRoomAppState extends ConsumerState<SyncRoomApp> {
  @override
  void initState() {
    super.initState();
    ref.listen(authStateProvider, (previous, next) {
      if (next.valueOrNull != null) {
        ref.read(pushServiceProvider).registerToken();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sync Room',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
